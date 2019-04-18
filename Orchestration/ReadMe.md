# Orchestration

[Back](../ReadMe.md)

25% of exam.

<details>
<summary>Content​ ​may​ ​include​ ​the​ ​following: </summary>

+ [Complete​ ​the​ ​setup​ ​of​ ​a​ ​swarm​ ​mode​ ​cluster,​ ​with​ ​managers​ ​and​ ​worker​ ​nodes](#setup) 
+ [State​ ​the​ ​differences​ ​between​ ​running​ ​a​ ​container​ ​vs​ ​running​ ​a​ ​service](./container-vs-service.md))
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

### <a name="setup"></a>Complete​ ​the​ ​setup​ ​of​ ​a​ ​swarm​ ​mode​ ​cluster ​with​ ​managers​ ​and​ ​worker​ ​nodes 

#### Prep: Create VMs

First, quickly create a virtual switch for your virtual machines (VMs) to share, 
so they can connect to each other.

1. Launch Hyper-V Manager
2. Click Virtual Switch Manager in the right-hand menu
3. Click Create Virtual Switch of type External
4. Give it the name myswitch, and check the box to share your host machine’s active network adapter

```
# create vms
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1

docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm2

# show vms
docker-machine ls
```

Set environment variables to dictate that docker should run a command against a particular machine.

##### enable ssh shell for machine
```
docker-machine env myvm1
```
or 

```
docker-machine ssh myvm1 <command>

```

Run docker-machine ls to verify that myvm1 is the active machine as indicated by the asterisk next to it:

```
docker-machine ls
```

| Port | About |
| --- | --- |
| 2377 | the swarm management port |
| 2376 | the Docker daemon port |

#### Build and publish Docker image

```
# login to Docker
 docker login

# build the image
docker build --tag=getting-started ./Getting-Started/Part-2

 # tag the image
 docker tag getting-started shailensukul/getting-started:part2

 # see your tagged image
 docker image ls

# publish the image
docker push shailensukul/getting-started:part2

# pull and run image from repository
docker run -p 4000:80 shailensukul/getting-started:part2
```

#### Add Workers and Managers to a Swarm

Note: run this commands via SSHing into the machine:

```
docker-machine env <machine>
```

Or

```
docker-machine ssh <machine> <command>
```

Run this on the manager node/vm
```
$ docker swarm init --advertise-addr=192.168.86.25 
```
Ip is manager vm ip address.
Swarm initialized: current node is now a manager.

Get join token for the manager
```
$ docker swarm join-token manager
```

 Get join token for the worker

```
$ docker swarm join-token worker
```

Make a dockerized node the manager
```
$ docker swarm join --token <Manager token> 192.168.86.25:2377
```
where ip is manager ip

Make a dockerized node the worker

```
$ docker swarm join --token <Worker token> 192.168.86.25:2377
```
where ip is manager ip

$ docker swarm join --token <Worker token> 192.168.86.25:2377

#### Deploy the app on the swarm manager

```
docker stack deploy -c docker-compose.yml getstartedlab
```

### Take down the app
```
docker stack rm part3
```

### Take down the swarm
```
docker swarm leave --force
```

