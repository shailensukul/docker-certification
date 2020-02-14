# Orchestration > Deploy Service To The Swarm

[Back](./ReadMe.md)

```
docker service create --replicas 1 --name helloworld alpine ping docker.com
```

* The docker service create command creates the service.
* The --name flag names the service helloworld.
* The --replicas flag specifies the desired state of 1 running instance.
* The arguments alpine ping docker.com define the service as an Alpine Linux container that executes the command ping docker.com.

Run '''docker service ls''' to see the list of running services: