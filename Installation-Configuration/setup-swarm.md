# Setup Swarm

[Back](./ReadMe.md)


## On the manager node

`docker swarm init --advertise-addr 165.22.100.124`

where ip address is manager's ip

Get the worker join token

`docker swarm join-token worker`

Use the token to join as worker:

`docker swarm join --token SWMTKN-1-34bqjzw2i7cy8h2n5bxrc7nxs21dzuq5htg6i924ywx5o66xli-26gmix6kwcxkbxypzhm6bxhq0 165.22.100.124:2377`