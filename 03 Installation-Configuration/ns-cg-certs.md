# Installation-Configuration > Understand ​​namespaces,​ ​cgroups,​ ​and​ ​configuration ​​of ​​certificates

[Back](./ReadMe.md)

Docker overview
===============

Estimated reading time: 10 minutes

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker's methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

The Docker platform[](https://docs.docker.com/engine/docker-overview/#namespaces#the-docker-platform)
-----------------------------------------------------------------------------------------------------

Docker provides the ability to package and run an application in a loosely isolated environment called a container. The isolation and security allow you to run many containers simultaneously on a given host. Containers are lightweight because they don't need the extra load of a hypervisor, but run directly within the host machine's kernel. This means you can run more containers on a given hardware combination than if you were using virtual machines. You can even run Docker containers within host machines that are actually virtual machines!

Docker provides tooling and a platform to manage the lifecycle of your containers:

-   Develop your application and its supporting components using containers.
-   The container becomes the unit for distributing and testing your application.
-   When you're ready, deploy your application into your production environment, as a container or an orchestrated service. This works the same whether your production environment is a local data center, a cloud provider, or a hybrid of the two.

Docker Engine[](https://docs.docker.com/engine/docker-overview/#namespaces#docker-engine)
-----------------------------------------------------------------------------------------

*Docker Engine* is a client-server application with these major components:

-   A server which is a type of long-running program called a daemon process (the `dockerd` command).

-   A REST API which specifies interfaces that programs can use to talk to the daemon and instruct it what to do.

-   A command line interface (CLI) client (the `docker` command).

![Docker Engine Components Flow](https://docs.docker.com/engine/images/engine-components-flow.png)

The CLI uses the Docker REST API to control or interact with the Docker daemon through scripting or direct CLI commands. Many other Docker applications use the underlying API and CLI.

The daemon creates and manages Docker *objects*, such as images, containers, networks, and volumes.

> Note: Docker is licensed under the open source Apache 2.0 license.

For more details, see [Docker Architecture](https://docs.docker.com/engine/docker-overview/#docker-architecture) below.

What can I use Docker for?[](https://docs.docker.com/engine/docker-overview/#namespaces#what-can-i-use-docker-for)
------------------------------------------------------------------------------------------------------------------

Fast, consistent delivery of your applications

Docker streamlines the development lifecycle by allowing developers to work in standardized environments using local containers which provide your applications and services. Containers are great for continuous integration and continuous delivery (CI/CD) workflows.

Consider the following example scenario:

-   Your developers write code locally and share their work with their colleagues using Docker containers.
-   They use Docker to push their applications into a test environment and execute automated and manual tests.
-   When developers find bugs, they can fix them in the development environment and redeploy them to the test environment for testing and validation.
-   When testing is complete, getting the fix to the customer is as simple as pushing the updated image to the production environment.

Responsive deployment and scaling

Docker's container-based platform allows for highly portable workloads. Docker containers can run on a developer's local laptop, on physical or virtual machines in a data center, on cloud providers, or in a mixture of environments.

Docker's portability and lightweight nature also make it easy to dynamically manage workloads, scaling up or tearing down applications and services as business needs dictate, in near real time.

Running more workloads on the same hardware

Docker is lightweight and fast. It provides a viable, cost-effective alternative to hypervisor-based virtual machines, so you can use more of your compute capacity to achieve your business goals. Docker is perfect for high density environments and for small and medium deployments where you need to do more with fewer resources.

Docker architecture[](https://docs.docker.com/engine/docker-overview/#namespaces#docker-architecture)
-----------------------------------------------------------------------------------------------------

Docker uses a client-server architecture. The Docker *client* talks to the Docker *daemon*, which does the heavy lifting of building, running, and distributing your Docker containers. The Docker client and daemon *can* run on the same system, or you can connect a Docker client to a remote Docker daemon. The Docker client and daemon communicate using a REST API, over UNIX sockets or a network interface.

![Docker Architecture Diagram](https://docs.docker.com/engine/images/architecture.svg)

### The Docker daemon[](https://docs.docker.com/engine/docker-overview/#namespaces#the-docker-daemon)

The Docker daemon (`dockerd`) listens for Docker API requests and manages Docker objects such as images, containers, networks, and volumes. A daemon can also communicate with other daemons to manage Docker services.

### The Docker client[](https://docs.docker.com/engine/docker-overview/#namespaces#the-docker-client)

The Docker client (`docker`) is the primary way that many Docker users interact with Docker. When you use commands such as `docker run`, the client sends these commands to `dockerd`, which carries them out. The `docker` command uses the Docker API. The Docker client can communicate with more than one daemon.

### Docker registries[](https://docs.docker.com/engine/docker-overview/#namespaces#docker-registries)

A Docker *registry* stores Docker images. Docker Hub is a public registry that anyone can use, and Docker is configured to look for images on Docker Hub by default. You can even run your own private registry. If you use Docker Datacenter (DDC), it includes Docker Trusted Registry (DTR).

When you use the `docker pull` or `docker run` commands, the required images are pulled from your configured registry. When you use the `docker push` command, your image is pushed to your configured registry.

### Docker objects[](https://docs.docker.com/engine/docker-overview/#namespaces#docker-objects)

When you use Docker, you are creating and using images, containers, networks, volumes, plugins, and other objects. This section is a brief overview of some of those objects.

#### IMAGES

An *image* is a read-only template with instructions for creating a Docker container. Often, an image is *based on* another image, with some additional customization. For example, you may build an image which is based on the `ubuntu` image, but installs the Apache web server and your application, as well as the configuration details needed to make your application run.

You might create your own images or you might only use those created by others and published in a registry. To build your own image, you create a *Dockerfile* with a simple syntax for defining the steps needed to create the image and run it. Each instruction in a Dockerfile creates a layer in the image. When you change the Dockerfile and rebuild the image, only those layers which have changed are rebuilt. This is part of what makes images so lightweight, small, and fast, when compared to other virtualization technologies.

#### CONTAINERS

A container is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI. You can connect a container to one or more networks, attach storage to it, or even create a new image based on its current state.

By default, a container is relatively well isolated from other containers and its host machine. You can control how isolated a container's network, storage, or other underlying subsystems are from other containers or from the host machine.

A container is defined by its image as well as any configuration options you provide to it when you create or start it. When a container is removed, any changes to its state that are not stored in persistent storage disappear.

##### Example `docker run` command

The following command runs an `ubuntu` container, attaches interactively to your local command-line session, and runs `/bin/bash`.

```
$ docker run -i -t ubuntu /bin/bash

```

When you run this command, the following happens (assuming you are using the default registry configuration):

1.  If you do not have the `ubuntu` image locally, Docker pulls it from your configured registry, as though you had run `docker pull ubuntu` manually.

2.  Docker creates a new container, as though you had run a `docker container create` command manually.

3.  Docker allocates a read-write filesystem to the container, as its final layer. This allows a running container to create or modify files and directories in its local filesystem.

4.  Docker creates a network interface to connect the container to the default network, since you did not specify any networking options. This includes assigning an IP address to the container. By default, containers can connect to external networks using the host machine's network connection.

5.  Docker starts the container and executes `/bin/bash`. Because the container is running interactively and attached to your terminal (due to the `-i` and `-t` flags), you can provide input using your keyboard while the output is logged to your terminal.

6.  When you type `exit` to terminate the `/bin/bash` command, the container stops but is not removed. You can start it again or remove it.

#### SERVICES

Services allow you to scale containers across multiple Docker daemons, which all work together as a *swarm* with multiple *managers* and *workers*. Each member of a swarm is a Docker daemon, and the daemons all communicate using the Docker API. A service allows you to define the desired state, such as the number of replicas of the service that must be available at any given time. By default, the service is load-balanced across all worker nodes. To the consumer, the Docker service appears to be a single application. Docker Engine supports swarm mode in Docker 1.12 and higher.

The underlying technology[](https://docs.docker.com/engine/docker-overview/#namespaces#the-underlying-technology)
-----------------------------------------------------------------------------------------------------------------

Docker is written in [Go](https://golang.org/) and takes advantage of several features of the Linux kernel to deliver its functionality.

### Namespaces[](https://docs.docker.com/engine/docker-overview/#namespaces#namespaces)

Docker uses a technology called `namespaces` to provide the isolated workspace called the *container*. When you run a container, Docker creates a set of *namespaces* for that container.

These namespaces provide a layer of isolation. Each aspect of a container runs in a separate namespace and its access is limited to that namespace.

Docker Engine uses namespaces such as the following on Linux:

-   The `pid` namespace: Process isolation (PID: Process ID).
-   The `net` namespace: Managing network interfaces (NET: Networking).
-   The `ipc` namespace: Managing access to IPC resources (IPC: InterProcess Communication).
-   The `mnt` namespace: Managing filesystem mount points (MNT: Mount).
-   The `uts` namespace: Isolating kernel and version identifiers. (UTS: Unix Timesharing System).

### Control groups[](https://docs.docker.com/engine/docker-overview/#namespaces#control-groups)

Docker Engine on Linux also relies on another technology called *control groups* (`cgroups`). A cgroup limits an application to a specific set of resources. Control groups allow Docker Engine to share available hardware resources to containers and optionally enforce limits and constraints. For example, you can limit the memory available to a specific container.

### Union file systems[](https://docs.docker.com/engine/docker-overview/#namespaces#union-file-systems)

Union file systems, or UnionFS, are file systems that operate by creating layers, making them very lightweight and fast. Docker Engine uses UnionFS to provide the building blocks for containers. Docker Engine can use multiple UnionFS variants, including AUFS, btrfs, vfs, and DeviceMapper.

### Container format[](https://docs.docker.com/engine/docker-overview/#namespaces#container-format)

Docker Engine combines the namespaces, control groups, and UnionFS into a wrapper called a container format. The default container format is `libcontainer`. In the future, Docker may support other container formats by integrating with technologies such as BSD Jails or Solaris Zones.

Protect the Docker daemon socket
================================

Estimated reading time: 7 minutes

By default, Docker runs through a non-networked UNIX socket. It can also optionally communicate using an HTTP socket.

If you need Docker to be reachable through the network in a safe manner, you can enable TLS by specifying the `tlsverify` flag and pointing Docker's `tlscacert` flag to a trusted CA certificate.

In the daemon mode, it only allows connections from clients authenticated by a certificate signed by that CA. In the client mode, it only connects to servers with a certificate signed by that CA.

> Advanced topic
>
> Using TLS and managing a CA is an advanced topic. Please familiarize yourself with OpenSSL, x509, and TLS before using it in production.

Create a CA, server and client keys with OpenSSL[](https://docs.docker.com/engine/security/https/#create-a-ca-server-and-client-keys-with-openssl)
--------------------------------------------------------------------------------------------------------------------------------------------------

> Note: Replace all instances of `$HOST` in the following example with the DNS name of your Docker daemon's host.

First, on the Docker daemon's host machine, generate CA private and public keys:

```
$ openssl genrsa -aes256 -out ca-key.pem 4096
Generating RSA private key, 4096 bit long modulus
............................................................................................................................................................................................++
........++
e is 65537 (0x10001)
Enter pass phrase for ca-key.pem:
Verifying - Enter pass phrase for ca-key.pem:

$ openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
Enter pass phrase for ca-key.pem:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:Queensland
Locality Name (eg, city) []:Brisbane
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Docker Inc
Organizational Unit Name (eg, section) []:Sales
Common Name (e.g. server FQDN or YOUR name) []:$HOST
Email Address []:Sven@home.org.au

```

Now that you have a CA, you can create a server key and certificate signing request (CSR). Make sure that "Common Name" matches the hostname you use to connect to Docker:

> Note: Replace all instances of `$HOST` in the following example with the DNS name of your Docker daemon's host.

```
$ openssl genrsa -out server-key.pem 4096
Generating RSA private key, 4096 bit long modulus
.....................................................................++
.................................................................................................++
e is 65537 (0x10001)

$ openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

```

Next, we're going to sign the public key with our CA:

Since TLS connections can be made through IP address as well as DNS name, the IP addresses need to be specified when creating the certificate. For example, to allow connections using `10.10.10.20` and `127.0.0.1`:

```
$ echo subjectAltName = DNS:$HOST,IP:10.10.10.20,IP:127.0.0.1 >> extfile.cnf

```

Set the Docker daemon key's extended usage attributes to be used only for server authentication:

```
$ echo extendedKeyUsage = serverAuth >> extfile.cnf

```

Now, generate the signed certificate:

```
$ openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem\
  -CAcreateserial -out server-cert.pem -extfile extfile.cnf
Signature ok
subject=/CN=your.host.com
Getting CA Private Key
Enter pass phrase for ca-key.pem:

```

[Authorization plugins](https://docs.docker.com/engine/extend/plugins_authorization) offer more fine-grained control to supplement authentication from mutual TLS. In addition to other information described in the above document, authorization plugins running on a Docker daemon receive the certificate information for connecting Docker clients.

For client authentication, create a client key and certificate signing request:

> Note: For simplicity of the next couple of steps, you may perform this step on the Docker daemon's host machine as well.

```
$ openssl genrsa -out key.pem 4096
Generating RSA private key, 4096 bit long modulus
.........................................................++
................++
e is 65537 (0x10001)

$ openssl req -subj '/CN=client' -new -key key.pem -out client.csr

```

To make the key suitable for client authentication, create a new extensions config file:

```
$ echo extendedKeyUsage = clientAuth > extfile-client.cnf

```

Now, generate the signed certificate:

```
$ openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem\
  -CAcreateserial -out cert.pem -extfile extfile-client.cnf
Signature ok
subject=/CN=client
Getting CA Private Key
Enter pass phrase for ca-key.pem:

```

After generating `cert.pem` and `server-cert.pem` you can safely remove the two certificate signing requests and extensions config files:

```
$ rm -v client.csr server.csr extfile.cnf extfile-client.cnf

```

With a default `umask` of 022, your secret keys are *world-readable* and writable for you and your group.

To protect your keys from accidental damage, remove their write permissions. To make them only readable by you, change file modes as follows:

```
$ chmod -v 0400 ca-key.pem key.pem server-key.pem

```

Certificates can be world-readable, but you might want to remove write access to prevent accidental damage:

```
$ chmod -v 0444 ca.pem server-cert.pem cert.pem

```

Now you can make the Docker daemon only accept connections from clients providing a certificate trusted by your CA:

```
$ dockerd --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem\
  -H=0.0.0.0:2376

```

To connect to Docker and validate its certificate, provide your client keys, certificates and trusted CA:

> Run it on the client machine
>
> This step should be run on your Docker client machine. As such, you need to copy your CA certificate, your server certificate, and your client certificate to that machine.

> Note: Replace all instances of `$HOST` in the following example with the DNS name of your Docker daemon's host.

```
$ docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem\
  -H=$HOST:2376 version

```

> Note: Docker over TLS should run on TCP port 2376.

> Warning: As shown in the example above, you don't need to run the `docker` client with `sudo` or the `docker` group when you use certificate authentication. That means anyone with the keys can give any instructions to your Docker daemon, giving them root access to the machine hosting the daemon. Guard these keys as you would a root password!

Secure by default[](https://docs.docker.com/engine/security/https/#secure-by-default)
-------------------------------------------------------------------------------------

If you want to secure your Docker client connections by default, you can move the files to the `.docker` directory in your home directory --- and set the `DOCKER_HOST` and `DOCKER_TLS_VERIFY` variables as well (instead of passing `-H=tcp://$HOST:2376` and `--tlsverify` on every call).

```
$ mkdir -pv ~/.docker
$ cp -v {ca,cert,key}.pem ~/.docker

$ export DOCKER_HOST=tcp://$HOST:2376 DOCKER_TLS_VERIFY=1

```

Docker now connects securely by default:

```
$ docker ps

```

Other modes[](https://docs.docker.com/engine/security/https/#other-modes)
-------------------------------------------------------------------------

If you don't want to have complete two-way authentication, you can run Docker in various other modes by mixing the flags.

### Daemon modes[](https://docs.docker.com/engine/security/https/#daemon-modes)

-   `tlsverify`, `tlscacert`, `tlscert`, `tlskey` set: Authenticate clients
-   `tls`, `tlscert`, `tlskey`: Do not authenticate clients

### Client modes[](https://docs.docker.com/engine/security/https/#client-modes)

-   `tls`: Authenticate server based on public/default CA pool
-   `tlsverify`, `tlscacert`: Authenticate server based on given CA
-   `tls`, `tlscert`, `tlskey`: Authenticate with client certificate, do not authenticate server based on given CA
-   `tlsverify`, `tlscacert`, `tlscert`, `tlskey`: Authenticate with client certificate and authenticate server based on given CA

If found, the client sends its client certificate, so you just need to drop your keys into `~/.docker/{ca,cert,key}.pem`. Alternatively, if you want to store your keys in another location, you can specify that location using the environment variable `DOCKER_CERT_PATH`.

```
$ export DOCKER_CERT_PATH=~/.docker/zone1/
$ docker --tlsverify ps

```

### Connecting to the secure Docker port using `curl`[](https://docs.docker.com/engine/security/https/#connecting-to-the-secure-docker-port-using-curl)

To use `curl` to make test API requests, you need to use three extra command line flags:

```
$ curl https://$HOST:2376/images/json\
  --cert ~/.docker/cert.pem\
  --key ~/.docker/key.pem\
  --cacert ~/.docker/ca.pem
```
