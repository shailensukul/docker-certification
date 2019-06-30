# [Docker Trusted Registry](https://docs.docker.com/ee/dtr/)

[Back](./ReadMe.md)

Docker Trusted Registry (DTR) is a containerized application that runs on a swarm managed by the Universal Control Plane (UCP). It can be installed on-premises or on a cloud infrastructure.

Docker Trusted Registry (DTR) is the enterprise-grade image storage solution from Docker. You install it behind your firewall so that you can securely store and manage the Docker images you use in your applications.

## Built-in access control
DTR uses the same authentication mechanism as Docker Universal Control Plane. Users can be managed manually or synchronized from LDAP or Active Directory. DTR uses Role Based Access Control (RBAC) to allow you to implement fine-grained access control policies for your Docker images.

## Install DTR
```
# Pull the latest version of DTR
$ docker pull docker/dtr:2.6.7

# Install DTR
$ docker run -it --rm \
  docker/dtr:2.6.7 install \
  --ucp-node <ucp-node-name> \
  --ucp-insecure-tls
```
```
docker run -it --rm docker/dtr install \
 --ucp-node node01 \
 --ucp-username [ucp username] \
  --ucp-url https://[swarm-01 IP] \
  --ucp-insecure-tls --replica-http-port 81 --replica-https-port 444
```

You can run that snippet on any node where Docker is installed. 
Confirm that DTR is installed via UCP.
![Docker Trusted Registry Installed](./dtr-confirm.png)

You can also browse to the DTR web interface:
```
http://[swarm-01-ip]:81
```

![DTR Web Interface](./dtr-web-interface.png)

