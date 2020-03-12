# Security > Describe​ ​MTLS

[Back](./ReadMe.md)

[Hitless TLS Certificate Rotation in Go](https://diogomonica.com/2017/01/11/hitless-tls-certificate-rotation-in-go/)
======================================

One of the core security goals of Docker's [Swarm mode](https://docs.docker.com/engine/swarm/) is to be secure by default. To achieve that, when [a new Swarm gets created](https://docs.docker.com/engine/reference/commandline/swarm_init/) it generates a self-signed Certificate Authority (CA) and issues short-lived[[1]](https://diogomonica.com/2017/01/11/hitless-tls-certificate-rotation-in-go/#fn1) certificates to every node, allowing the use of [Mutually Authenticated TLS](https://en.wikipedia.org/wiki/Mutual_authentication) for node-to-node communications.

![Mutual TLS between Swarm nodes.](https://diogomonica.com/content/images/2017/01/swarm-with-mutual-tls-simple.png)

Unfortunately, and much to the annoyance of every infrastructure engineer, there is an old TLS maxim that states that:

> If a certificate got issued, it will have to be rotated.

Rotating TLS certificates manually may quickly get out of hand---particularly when we have to manage hundreds of certificates---and becomes completely unmanageable if we issue certificates that expire within hours, instead of months.

In this post I'll go over two different ways of doing hitless certificate rotation in Go, so that we can follow the only logical path out of this certificate management nightmare: automate the hell out of TLS certificate rotation.

### Why do I need hitless rotation?

There are some use-cases where replacing the TLS certificate on disk and restarting the application is a completely valid way of doing certificate rotation.

In fact, if we do a rolling deploy of our application---by adding new application instances with the new certificate before shutting down the instances with the old certificate---we can achieve hitless rotation[[2]](https://diogomonica.com/2017/01/11/hitless-tls-certificate-rotation-in-go/#fn2) and none of the incoming requests to the application will be dropped.

![Rotation between App versions A and B, using a Load Balancer.](https://diogomonica.com/content/images/2017/01/load-balancer-hitless-rotation-1.png)

Unfortunately, there are two main issues with this approach:

-   There might be side-effects to shutting down the old instances (e.g., applications losing their caches).
-   We either have to wait for all the currently active TCP connections of our old instances to finish (i.e., we might have to wait a long time) or forcefully terminate all the current open connections.

As a concrete example, consider the Docker Swarm architecture, depicted in the following Figure. To create highly-available clusters, Swarm uses special manager nodes participating in a consensus protocol called Raft. Manager nodes keep long-lived connections between each other, and all the other nodes in the system (workers) maintain a long-lived connection to one of the managers.

![Swarm Architecture.](https://diogomonica.com/content/images/2017/01/swarm-raft-cluster-1.png)

If we were to use the previously described rolling--deploy method to rotate the certificates on the manager nodes, we would:

-   Cause a thundering herd of workers attempting to reconnect their terminated connections with the managers.
-   Potentially cause a leader election between the managers, bringing unnecessary disruption to our cluster while Raft converges to a new leader.

To make matters worse, if our certificates have short expiration times, these two issues would occur several times a day.

Fortunately, there is a better way.

### Certificate selection during the TLS handshake

In a TLS handshake, the certificate presented by a remote server is sent alongside the `ServerHello` message. At this point in the connection, the remote server has received the `ClientHello` message, and that is all the information it needs to decide which certificate to present to the connecting client.

![Beginning of TLS handshake](https://diogomonica.com/content/images/2017/01/begining-tls-handshake-1.png)

It turns out that Go supports passing a callback in a TLS Config that will get executed every time a TLS `ClientHello` is sent by a remote peer. This method is conveniently called `GetCertificate`, and it returns the certificate we wish to use for that particular TLS handshake.

The idea of `GetCertificate` is to allow the dynamic selection of which certificate to provide to a particular remote peer. This method can be used to support virtual hosts, where one web server is responsible for multiple domains, and therefore has to choose the appropriate certificate to return to each remote peer.

![Certificate Selection during handshake](https://diogomonica.com/content/images/2017/01/certificate-selection-during-handshake-1.png)

Using `GetCertificate` is easy. The first thing we need to do is to create a `struct` that implements the `GetCertificate(clientHello *tls.ClientHelloInfo)` method[[3]](https://diogomonica.com/2017/01/11/hitless-tls-certificate-rotation-in-go/#fn3).

```
type wrappedCertificate struct {
	sync.Mutex
	certificate *tls.Certificate
}

func (c *wrappedCertificate) getCertificate(clientHello *tls.ClientHelloInfo) (*tls.Certificate, error) {
	c.Lock()
	defer c.Unlock()

	return c.certificate, nil
}

```

After this, we can create a TLS Config that makes use of this method, and a TLS listener that makes use of this config:

```
wrappedCert := &wrappedCertificate{}
config := &tls.Config{
	GetCertificate: wrappedCert.getCertificate,
	PreferServerCipherSuites: true,
	MinVersion:               tls.VersionTLS12,
}
network := "0.0.0.0:8080"
listener, _ := tls.Listen("tcp", network, config)

```

Every time a TLS handshake is about to occur, our `getCertificate` method is going to get called, and the current certificate stored inside `wrappedCertificate` will be returned.

However, we are missing a way of replacing the internal certificate that is returned by `getCertificate`. Let's fix that:

```
func (c *wrappedCertificate) loadCertificate(cert, key []byte) error {
	c.Lock()
	defer c.Unlock()

	certAndKey, err := tls.X509KeyPair(cert, key)
	if err != nil {
		return err
	}

	c.certificate = &certAndKey

	return nil
}

```

This `loadCertificate()` method allows updating the certificate stored inside `wrappedCertificate`, successfully achieving our goal of doing certificate rotation without killing the currently active connections.

Here's a diagram of what is happening:

![Golang application changes the certificate currently being served.](https://diogomonica.com/content/images/2017/01/golang-new-certificate-being-served.png)

Old established connections using the previous certificate will remain active, but new connections coming in to our TLS server will use the most recent certificate.

Here is a [simple example](https://github.com/diogomonica/certificate-rotation/blob/master/certificate_rotation.go) of a TLS server that rotates its certificates every second. Every new certificate gets generated with random Organization (`O=`); running this example and doing a few handshakes shows us that the server is indeed rotating certificates at every second:

```
➜ go build certificate_rotation.go; ./certificate_rotation
Generating new certificates.
Generating new certificates.

```

```
➜  ~ openssl s_client -connect localhost:8080 -no_ssl3 -no_ssl2 | openssl x509 -text | grep "O="
depth=0 /O=YSvkxjrK1UGexUg1KubNtrfXRhyRF-AxPPtXZxXkiKk=
...
➜  ~ openssl s_client -connect localhost:8080 -no_ssl3 -no_ssl2 | openssl x509 -text | grep "O="
depth=0 /O=aQIkDOpBwUDLdCLAGvnY8C5vRlmV0eDn2hRf_zTgpxk=
...

```

For a more complex use of `GetCertificate` take a look at the autocert package in [`golang.org/x/crypto/acme/autocert`](https://github.com/golang/crypto/blob/master/acme/autocert/autocert.go), which does domain-based lookups on a memory cache hosting all the currently available certificates.

### Choosing the TLS config before the TLS handshake

There is another way of achieving the same goal of certificate rotation in Go. Instead of relying on `GetCertificate`to be called on every TLS handshake and choosing which certificate gets used, we can create a new TLS server for every accepted TCP connection, and provide whatever TLS config is active at the time.

The major advantage of this particular route is the fact that we are no longer stuck with the same TLS config parameters for every connection, and we can change any TLS Config parameters on the fly.

To do this, we create a `wrappedConfig struct`, instead of a `wrappedCertificate struct`:

```
type wrappedConfig struct {
	sync.Mutex
	config *tls.Config
}

func (c *wrappedConfig) getConfig() *tls.Config {
	c.Lock()
	defer c.Unlock()

	return c.config
}

```

The major difference from the previous method lies in not using a `tls.Listener`, and instead manually creating a `tls.Server` with the desired TLS config on every `net.Listener.Accept()`.

```

	wrappedConfig := &wrappedConfig{}
	network := "0.0.0.0:8080"
	listener, _ := net.Listen("tcp", network)
...
	conn, _ := listener.Accept()
	config := wrappedConfig.getConfig()
	conn = tls.Server(conn, config)

```

Why is this useful? In the previous solution we were only able to control which certificate was returned. This method now allows us to switch any parameter inside the config, enabling use-cases such as root CA rotation or dynamic selection of cipher suites.

Here is a [silly example](https://github.com/diogomonica/certificate-rotation/blob/master/config_rotation.go) to show config rotations.

We have a [simple server](https://github.com/diogomonica/certificate-rotation/blob/master/config_rotation.go) that rotates it's own TLS Config every second, not only renewing its certificate, but also switching between supporting TLS 1.2 only, or supporting anything above SSL3.0. On the client side, we will have a client that will only attempt to use TLS 1.0. Let's see what happens:

```
➜ openssl s_client -connect localhost:8080 -tls1
CONNECTED(00000003)
depth=0 /O=lJfunYUG8zk8c8Q9JeYALONSgHpUkPIdkwoBXU2bqfU=
...
➜ openssl s_client -connect localhost:8080 -tls1
CONNECTED(00000003)
17760:error:1409E0E5:SSL routines:SSL3_WRITE_BYTES:ssl handshake failure:/BuildRoot/Library/Caches/com.apple.xbs/Sources/OpenSSL098/OpenSSL098-64/src/ssl/s3_pkt.c:566:
➜  openssl s_client -connect localhost:8080 -tls1
CONNECTED(00000003)
depth=0 /O=Df0ksueEUr6-ka5Vz9HH8LILPA_Webim4kBa3rMroLM=
...

```

As expected, the first `s_connect` succeeds, the second one fails, and the third one again succeeds. The server will continue flipping the minimum allowed TLS version back and forth, and the client will continue to alternate between successfully creating a TLS 1.0 connection, and being rejected for not supporting TLS 1.2.

### Certificate rotation in Docker Swarm

One of our objectives with Docker Swarm is to support transparent root rotation. The idea is to allow an administrator to force the whole cluster to migrate away from an old root CA transparently, removing its existence from the trust stores of all the nodes participating in the Swarm. This means that we need control over the whole TLS config, instead of controlling only which certificate is currently being served.

To slightly complicate matters, we have to rotate not only the server certificates, but also the client certificates being actively used for [Mutually Authenticated TLS](https://en.wikipedia.org/wiki/Mutual_authentication) by every node.

Finally, Swarm also makes heavy use of [gRPC](http://www.grpc.io/), which is a a high-performance, open-source, universal RPC framework. Therefore, we will have to integrate our `wrappedConfig` style config rotation with the gRPC's authentication model.

It turns out that gRPC provides a simple authentication API that allows us to define custom methods for performing the client and server handshakes by simply implementing the [TransportCredentials](https://github.com/grpc/grpc-go/blob/master/credentials/credentials.go#L100) interface:

```
type TransportCredentials interface {
	ClientHandshake(context.Context, string, net.Conn) (net.Conn, AuthInfo, error)
	ServerHandshake(net.Conn) (net.Conn, AuthInfo, error)
	Info() ProtocolInfo
	Clone() TransportCredentials
	OverrideServerName(string) error
}

```

We chose to create a [MutableTLSCreds](https://github.com/docker/swarmkit/blob/master/ca/transport.go) struct, which implements this [TransportCredentials](https://godoc.org/google.golang.org/grpc/credentials) interface and allows the caller to simply change the TLS Config by calling `LoadNewTLSConfig`.

```
// MutableTLSCreds is the credentials required for authenticating a connection using TLS.
type MutableTLSCreds struct {
	// Mutex for the tls config
	sync.Mutex
	// TLS configuration
	config *tls.Config
	// TLS Credentials
	tlsCreds credentials.TransportCredentials
	// store the subject for easy access
	subject pkix.Name
}

```

Note that we had to implement both `ClientHandshake` and `ServerHandshake` to support transparent rotation of both server and client connections. You can find the full implementation [here](https://github.com/docker/swarmkit/blob/master/ca/transport.go).

### Changes coming in Golang 1.8

If the previous method seems a bit clunky to you, it's because it is. Thankfully, [Golang 1.8](https://blog.gopheracademy.com/advent-2016/go-1.8/) is bringing some changes that will help simplify this use-case. In particular, the addition of [GetConfigForClient](https://tip.golang.org/pkg/crypto/tls/#Config.GetConfigForClient) will allow us to dynamically change the server's TLS Config behavior based on the `ClientHello` message.

Additionally, Golang 1.8 is also adding support for ChaCha20-Poly1305 based cipher suites and the `VerifyPeerCertificate` method, which enables custom certificate checking logic.

### Conclusion

The ability of doing hitless TLS certificate rotation is critical to continue our quest of reducing certificate expiration times, while keeping our sanity intact.

Hopefully, at this point you'll agree with me that Golang makes it incredibly easy to support hitless TLS certificate rotation in your applications, so go forth and *rotate all the keys*.