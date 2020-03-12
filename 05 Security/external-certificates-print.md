# Security > Describe ​​process ​​to ​​use ​​external ​​certificates ​​with ​​UCP ​​and ​​DTR - Print the certificates

[Back](./ReadMe.md)

docker/ucp dump-certs
=====================

Estimated reading time: 1 minute

> The documentation herein is for UCP version 3.0.16.

Print the public certificates used by this UCP web server

Usage[](https://docs.docker.com/datacenter/ucp/3.0/reference/cli/dump-certs/#usage)
-----------------------------------------------------------------------------------

```
docker container run --rm\
    --name ucp\
    -v /var/run/docker.sock:/var/run/docker.sock\
    docker/ucp\
    dump-certs [command options]

```

Description[](https://docs.docker.com/datacenter/ucp/3.0/reference/cli/dump-certs/#description)
-----------------------------------------------------------------------------------------------

This command outputs the public certificates for the UCP web server running on this node. By default it prints the contents of the ca.pem and cert.pem files.

When integrating UCP and DTR, use this command with the `--cluster --ca` flags to configure DTR.

Options[](https://docs.docker.com/datacenter/ucp/3.0/reference/cli/dump-certs/#options)
---------------------------------------------------------------------------------------

| Option | Description |
| --- | --- |
| `--debug, D` | Enable debug mode |
| `--jsonlog` | Produce json formatted output for easier parsing |
| `--ca` | Only print the contents of the ca.pem file |
| `--cluster` | Print the internal UCP swarm root CA and cert instead of the public server cert |

