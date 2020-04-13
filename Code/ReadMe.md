# Code - Docker Compose Example

[Back](../ReadMe.md)

## App directory

In this example we have a .Net Core MVC application, which connects to a Redis instance.


## Building the dotnet core application locally:

```
dotnet build myapp.csproj
```

```
dotnet run myapp
```

Building and publishing the app's Docker file

```
docker build . -t shailensukul/mvcapp:1.0.0.0 -f Dockerfile
```

```
docker image ls
```

```
docker login
```

```
docker push shailensukul/mvcapp:1.0.0.0
```

## Docker Compose

The compose file will refer to the app we published above and a standard Redis image.
The app will connect to the Redis instance and store a counter value in it.

### Compose file
```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: shailensukul/mvcapp:1.0.0.0
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
    ports:
      - "80:80"
    networks:
    - webnet
  redis:
    image: redis:latest
    ports:
      - "6379:6379"
    volumes:
      - "/home:/data"
    deploy:
      placement:
        constraints: [node.role == manager]
    command: redis-server --appendonly yes
    networks:
        - webnet

networks:
      webnet:
```

Test it locally

```
docker-compose up
```

Browse to localhost

```
docker-compose down
```

## Deploy to a stack

```
docker stack deploy -c docker-compose.yml mcvstack
```

Take down the stack
```
docker stack rm mvcstack
```
