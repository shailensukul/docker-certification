Link: https://docs.docker.com/get-started/part4/


Tip: If commands do not respond, increase the timeout:

docker-machine ls -t 20

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
First, quickly create a virtual switch for your virtual machines (VMs) to share, 
so they can connect to each other.
1. Launch Hyper-V Manager
2. Click Virtual Switch Manager in the right-hand menu
3. Click Create Virtual Switch of type External
4. Give it the name myswitch, and check the box to share your host machine’s active network adapter

Now, create a couple of VMs using our node management tool, docker-machine:

docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm2

Show machines:

docker-machine ls

[Initialize the swarm and add nodes]
The first machine acts as the manager, which executes management commands and 
authenticates workers to join the swarm, and the second is a worker.

You can send commands to your VMs using docker-machine ssh. 
Instruct myvm1 to become a swarm manager with docker swarm init and look for output like this:

docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"

Example: docker-machine ssh myvm1 "docker swarm init --advertise-addr 192.168.86.25"

Swarm initialized: current node <node ID> is now a manager.

To add a worker to this swarm, run the following command:

  docker swarm join \
  --token <token> \
  <myvm ip>:<port>

Example: 
 docker-machine --native-ssh ssh myvm2 "docker swarm join --token \
 SWMTKN-1-30hdl4m0s6c0lqggli4gvcm8pmchmjwsnqzd2rkf4i15s01v9c-8ntkpcp24r17ug4qhegvq83rp \
 192.168.86.25:2377"

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[Ports 2377 and 2376]
Always run docker swarm init and docker swarm join with port 2377 (the swarm management port), 
or no port at all and let it take the default.
The machine IP addresses returned by docker-machine ls include port 2376,
 which is the Docker daemon port. 
Do not use this port or you may experience errors.

[Having trouble using SSH? Try the --native-ssh flag]
docker-machine --native-ssh ssh myvm1

[View the nodes in this swarm]:

docker-machine --native-ssh ssh myvm1
docker node ls

[Deploy your app on the swarm cluster]

[Docker machine shell environment on Windows]:
docker-machine env myvm1

Output:
SET DOCKER_TLS_VERIFY=1
SET DOCKER_HOST=tcp://192.168.86.25:2376
SET DOCKER_CERT_PATH=C:\Users\shail\.docker\machine\machines\myvm1
SET DOCKER_MACHINE_NAME=myvm1
SET COMPOSE_CONVERT_WINDOWS_PATHS=true
REM Run this command to configure your shell:
REM     @FOR /f "tokens=*" %i IN ('docker-machine env myvm1') DO @%i

Run the given command to configure your shell:
@FOR /f "tokens=*" %i IN ('docker-machine env myvm1') DO @%i

Run docker-machine ls to verify that myvm1 is the active machine as indicated by the asterisk next to it:

docker-machine ls

NAME    ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER     ERRORS
myvm1   *        hyperv   Running   tcp://192.168.86.25:2376           v18.09.3
myvm2   -        hyperv   Running   tcp://192.168.86.26:2376           v18.09.3

[Deploy the app on the swarm manager]

docker stack deploy -c docker-compose.yml getstartedlab

Verify:
Use the docker service ps <service_name> command on a swarm manager to verify 
that all services have been redeployed.


docker service ls
docker service ps getstartedlab_web

[Setup shell to a machine]

docker-machine env <machine>

and then run the given command

OR you can execute command by command:

docker-machine ssh <machine> "<command>"

[Connecting to VMs with docker-machine env and docker-machine ssh]
To set your shell to talk to a different machine like myvm2, simply re-run [docker-machine env] in 
the same or a different shell, then run the given command to point to myvm2. 
This is always specific to the current shell. If you change to an unconfigured shell or open a 
new one, you need to re-run the commands. Use [docker-machine ls] to list machines, see what state 
they are in, get IP addresses, and find out which one, if any,

Alternatively, you can wrap Docker commands in the form of [docker-machine ssh <machine> "<command>"],
which logs directly into the VM but doesn’t give you immediate access to files on your local host.

On Mac and Linux, you can use [docker-machine scp <file> <machine>:~] to copy files across machines, 
but Windows users need a Linux terminal emulator like Git Bash for this to work.

[Cleanup]
Tear down the stack:

docker stack rm getstartedlab

