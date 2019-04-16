# Orchestration

[Back](../ReadMe.md)

25% of exam.

<details>
<summary>Content​ ​may​ ​include​ ​the​ ​following: </summary>

+ Complete​ ​the​ ​setup​ ​of​ ​a​ ​swarm​ ​mode​ ​cluster,​ ​with​ ​managers​ ​and​ ​worker​ ​nodes 
+ State​ ​the​ ​differences​ ​between​ ​running​ ​a​ ​container​ ​vs​ ​running​ ​a​ ​service 
+ Demonstrate​ ​steps​ ​to​ ​lock​ ​a​ ​swarm​ ​cluster 
+ Extend​ ​the​ ​instructions​ ​to​ ​run​ ​individual​ ​containers​ ​into​ ​running​ ​services​ ​under​ ​swarm 
+ Interpret​ ​the​ ​output​ ​of​ ​"docker​ ​inspect"​ ​commands 
+ Convert​ ​an​ ​application​ ​deployment​ ​into​ ​a​ ​stack​ ​file​ ​using​ ​a​ ​YAML​ ​compose​ ​file​ ​with "docker​ ​stack​ ​deploy" 
+ Manipulate​ ​a​ ​running​ ​stack​ ​of​ ​services 
+ Increase​ ​#​ ​of​ ​replicas 
+ Add​ ​networks,​ ​publish​ ​ports 
+ Mount​ ​volumes 
+ Illustrate​ ​running​ ​a​ ​replicated​ ​vs​ ​global​ ​service 
+ Identify​ ​the​ ​steps​ ​needed​ ​to​ ​troubleshoot​ ​a​ ​service​ ​not​ ​deploying 
+ Apply​ ​node​ ​labels​ ​to​ ​demonstrate​ ​placement​ ​of​ ​tasks 
+ Sketch​ ​how​ ​a​ ​Dockerized​ ​application​ ​communicates​ ​with​ ​legacy​ ​systems 
+ Paraphrase ​the​ ​importance​ ​of​ ​quorum​ ​in​ ​a​ ​swarm​ ​cluster 
+ Demonstrate​ ​the​ ​usage​ ​of​ ​templates​ ​with​ ​"docker​ ​service​ ​create" 
</details>

### Create VMs

```
# create vms
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1

docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm2

# show vms
docker-machine ls

# enable ssh shell for machine
docker-machine env myvm1

```

### Complete​ ​the​ ​setup​ ​of​ ​a​ ​swarm​ ​mode​ ​cluster,​ ​with​ ​managers​ ​and​ ​worker​ ​nodes 

```
$ docker swarm init --advertise-addr=192.168.86.25 

# (default node becomes the only manager in the swarm)

# Get join token for the manager

$ docker swarm join-token manager

# Get join token for the worker

$ docker swarm join-token worker

# Make a dockerized node the manager

$ docker swarm join --token <Manager token> 192.168.86.25:2377

# where ip is manager ip

# Make a dockerized node the worker

$ docker swarm join --token <Worker token> 192.168.86.25:2377

# where ip is manager ip

$ docker node ls

```

### State the differences between running a container versus running a service

![Services vs Containers](/Images/services-diagram.png)