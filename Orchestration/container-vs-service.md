# Orchestration > State ​​the ​​differences ​​between​​ running ​​a ​​container​​ vs ​​running ​​a ​​service

[Back](./ReadMe.md)

[Reference](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#services-tasks-and-containers)

## Services, tasks, and containers

When you deploy the service to the swarm, the swarm manager accepts your service definition as the desired state for the service. 
Then it schedules the service on nodes in the swarm as one or more replica tasks. 
The tasks run independently of each other on nodes in the swarm.

For example, imagine you want to load balance between three instances of an HTTP listener. 
The diagram below shows an HTTP listener service with three replicas. Each of the three instances of the listener is a task in the swarm.

![Services][services
]
[services] ./services-diagram.png

## Running a service
```
$ docker service create --name redis redis:3.0.6
mnejoka8adtyb1vz6ejtw20ja
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged
```

## List the services
```
docker service ls
```

## Running a container
```
$ docker run -td --name redis-container redis:3.0.6
Unable to find image 'redis:3.0.6' locally
3.0.6: Pulling from library/redis
81cc5f26a6a0: Already exists
a3ed95caeb02: Already exists
d43cb752619e: Already exists
861e96e7ae14: Already exists
7fae3dcea8af: Already exists
b46c28ddbe0c: Already exists
2d50fb4bcfa7: Already exists
c8fc9e7dfb8b: Already exists
a1a961e320bc: Already exists
Digest: sha256:6a692a76c2081888b589e26e6ec835743119fe453d67ecf03df7de5b73d69842
Status: Downloaded newer image for redis:3.0.6
1dddbe5cc61bfe62df0b4eb73c5fb735b773ffefb477908cfe35bf71f58ef8af
[node1] (local) root@192.168.0.8 ~

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
1dddbe5cc61b        redis:3.0.6         "/entrypoint.sh redi…"   8 seconds ago       Up 7 seconds        6379/tcp            redis-container
62c3c4aa18da        redis:3.0.6         "/entrypoint.sh redi…"   7 minutes ago       Up 7 minutes        6379/tcp            redis.1.ibquqh186v5sc58ev7bpulojc
```
