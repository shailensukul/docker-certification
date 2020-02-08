[Back](./ReadMe.md)

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

#### Add Workers and Managers to a Swarm

##### SSH into a machine

```
docker-machine env <machine>
```

Or

```
docker-machine ssh <machine> <command>
```

#### Alternate Way - Log into Pi Swarm
Machines are:
* pi-1
* pi-2
* pi-3
* pi-4

[Setup details are here](https://github.com/shailensukul/pi-cluster)

```
ssh dockeradmin@pi-1
```

##### Run this on the manager node/vm

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

## Setup Swarm Mode

## What is Docker Stack
* Swarm - is a cluster of machines running Docker
* Stack - is a group of interrelated services that share dependencies, and can be orchestrated and scaled together

#### Deploy the app on the swarm manager

```
docker stack deploy -c docker-compose.yml getstartedlab
```

### Take down the app
```
docker stack rm getstartedlab
```

### Take down the swarm
```
docker swarm leave --force
```

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
