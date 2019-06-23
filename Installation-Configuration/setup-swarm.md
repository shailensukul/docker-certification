## Components of Docker Swarm 
Swarms are a cluster of nodes that consist of the following components:

● Manager Nodes: Tasks involved here include Control Orchestration, Cluster Management, and Task Distribution.

● Worker Nodes: Functions here include running containers and services that have been assigned by the manager node.

● Services: This gives a description of the blueprint via which an individual container can distribute itself across the nodes.

● Tasks: These are slots in which single containers place their work.

# Setup Swarm

[Back](./ReadMe.md)


## On the manager node

`docker swarm init --advertise-addr 165.22.100.124`

where ip address is manager's ip

Get the worker join token

`docker swarm join-token worker`

And the command for the manager token:

`docker swarm join-token manager`

Use the token to join as worker:

`docker swarm join --token SWMTKN-1-34bqjzw2i7cy8h2n5bxrc7nxs21dzuq5htg6i924ywx5o66xli-26gmix6kwcxkbxypzhm6bxhq0 165.22.100.124:2377`

Displays system wide information

`docker system info`

## Set backup schedule

