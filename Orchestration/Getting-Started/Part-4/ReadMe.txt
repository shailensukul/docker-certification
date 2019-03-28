Link: https://docs.docker.com/get-started/part4/
In part 4, you deploy this application onto a cluster, running it on multiple machines. 
Multi-container, multi-machine applications are made possible by joining multiple
machines into a “Dockerized” cluster called a swarm.

A swarm is a group of machines that are running Docker and joined into a cluster. 
After that has happened, you continue to run the Docker commands you’re used to, 
but now they are executed on a cluster by a swarm manager. 
The machines in a swarm can be physical or virtual. After joining a swarm, 
they are referred to as nodes.

Swarm managers can use several strategies to run containers, such as “emptiest node” -- which 
fills the least utilized machines with containers. Or “global”, which ensures that each 
machine gets exactly one instance of the specified container. 
You instruct the swarm manager to use these strategies in the Compose file, 
just like the one you have already been using.

Swarm managers are the only machines in a swarm that can execute your commands, 
or authorize other machines to join the swarm as workers. 
Workers are just there to provide capacity and do not have the authority to 
tell any other machine what it can and cannot do.

[Setup your Swarm]
A swarm is made up of multiple nodes, which can be either physical or virtual machines. 
The basic concept is simple enough:

docker swarm init

to enable swarm mode and make your current machine a swarm manager, then run

docker swarm join

on other machines to have them join the swarm as workers. 

[Create a Cluster]


