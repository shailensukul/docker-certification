# Orchestration > Convert​ ​an​ ​application​ ​deployment​ ​into​ ​a​ ​stack​ ​file​ ​using​ ​a​ ​YAML​ ​compose​ ​file​ ​with "docker​ ​stack​ ​deploy"

[Back](./ReadMe.md)

Deploy a new stack or update an existing stack

```
docker stack deploy [OPTIONS] STACK
```

```
docker stack deploy --compose-file docker-compose.yml vossibility
```

## Options
```
--bundle-file
```
Path to a Distributed Application Bundle file

```
--compose-file , -c
```
Path to a Compose file, or “-“ to read from stdin

```
--namespace
```
Kubernetes namespace to use

```
--prune
```
Prune services that are no longer referenced

```
--resolve-image
```

Query the registry to resolve image digest and supported platforms (“always”|”changed”|”never”)

```
--with-registry-auth
```
Send registry authentication details to Swarm agents

```
--kubeconfig
```
Kubernetes config file

```
--orchestrator
```
Orchestrator to use (swarm|kubernetes|all)


## Related Commands

List stacks
```
docker stack ls
```

List the tasks in the stack
```
docker stack ps
```

Remove one or more stacks
```
docker stack rm
```

List the services in the stack
```
docker stack services
```
