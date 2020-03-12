# Security > Describe ​​process ​​to ​​use ​​external ​​certificates ​​with ​​UCP ​​and ​​DTR - CLI

[Back](./ReadMe.md)

Authored by:[ Tammy Fox](https://success.docker.com/author/tfoxnc)

How do I provide an externally-generated security certificate during the UCP command line installation?
=======================================================================================================

By default, the UCP installation process secures the cluster via self-signed TLS certificates. For production usage, you should provide your own externally-generated, signed certificates. This article show how to provide externally-generated, signed certificates while installing UCP on the command line.

Prerequisites
-------------

This article assumes the following:

-   You are installing UCP via the command line as described in [Install UCP for production](https://docs.docker.com/ucp/installation/install-production/#step-5-install-the-ucp-controller "Install UCP for production") from the Docker docs.
-   You have a set of externally-generated, signed TLS certificates for your domain.
-   You are using UCP 1.1.1 and higher.

*NOTE:* This option was named `external-ucp-ca` in UCP 1.1.0 and earlier.

Steps
-----

To specify an externally-generated and signed certificate for the UCP controller during a command line installation, use the `--external-server-cert` option.

The cert files in the storage volume named `ucp-controller-server-certs` will be used when the `--external-server-cert` option is specified.

1.  First, create a storage volume named `ucp-controller-server-certs` with `ca.pem`, `cert.pem`, and `key.pem` in the root directory before running the install. It must contain the following:

    -   `ca.pem` - This should have exactly one certificate, and that should be the root certificate authority for the whole chain.
    -   `cert.pem` - This should have the actual certificate for UCP, and all its intermediate certificates. The actual certificate should be at the top. The next certificate should be the next certificate in the chain. The last certificate should be signed by the root certificate that appears in `ca.pem,/code>.`
    -   `key.pem` - This should have only the private key file and nothing else.
2.  Then, when installing UCP, use the `--external-server-cert` option:

    ```
    docker run --rm -it\
      --name ucp\
      -v /var/run/docker.sock:/var/run/docker.sock\
      docker/ucp\
      install\
      --external-server-cert\
      [command options]
    ```