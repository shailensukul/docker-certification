# Orchestration > Increase​ ​#​ ​of​ ​replicas

[Back](./ReadMe.md)

Scale one or multiple replicated services

```
docker service scale SERVICE=REPLICAS [SERVICE=REPLICAS...]
```

```
docker service scale frontend=50
```

## Options

Exit immediately instead of waiting for the service to converge
```
--detach , -d
```

