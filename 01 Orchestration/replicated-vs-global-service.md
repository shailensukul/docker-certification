# Orchestration > Illustrate​ ​running​ ​a​ ​replicated​ ​vs​ ​global​ ​service

[Back](./ReadMe.md)

There are two types of service deployments, replicated and global.

For a replicated service, you specify the number of identical tasks you want to run. For example, you decide to deploy an HTTP service with three replicas, each serving the same content.

A global service is a service that runs one task on every node. There is no pre-specified number of tasks. Each time you add a node to the swarm, the orchestrator creates a task and the scheduler assigns the task to the new node. Good candidates for global services are monitoring agents, an anti-virus scanners or other types of containers that you want to run on every node in the swarm.

The diagram below shows a three-service replica in yellow and a global service in gray.
![Replciated versus global service](./replicated-vs-global.png)

#### REPLICATED OR GLOBAL SERVICES

Swarm mode has two types of services: replicated and global. For replicated services, you specify the number of replica tasks for the swarm manager to schedule onto available nodes. For global services, the scheduler places one task on each available node that meets the service's [placement constraints](https://docs.docker.com/engine/swarm/services/#placement-constraints) and [resource requirements](https://docs.docker.com/engine/swarm/services/#reserve-memory-or-cpus-for-a-service).

You control the type of service using the `--mode` flag. If you don't specify a mode, the service defaults to `replicated`. For replicated services, you specify the number of replica tasks you want to start using the `--replicas` flag. For example, to start a replicated nginx service with 3 replica tasks:

```
$ docker service create\
  --name my_web\
  --replicas 3\
  nginx

```

To start a global service on each available node, pass `--mode global` to `docker service create`. Every time a new node becomes available, the scheduler places a task for the global service on the new node. For example to start a service that runs alpine on every node in the swarm:

```
$ docker service create\
  --name myservice\
  --mode global\
  alpine top
```