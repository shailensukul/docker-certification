# Setup Swarm

[Back](./ReadMe.md)


## On the manager node

`docker swarm init --advertise-addr 165.22.100.124`

where ip address is manager's ip

Get the worker join token

`docker swarm join-token worker`