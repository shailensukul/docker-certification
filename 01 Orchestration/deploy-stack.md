# Orchestration > Complete​ ​the​ ​setup​ ​of​ ​a​ ​swarm​ ​mode​ ​cluster,​ ​with​ ​managers​ ​and​ ​worker​ ​nodes

[Back](./ReadMe.md)

## Docker Compose File
```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: shailensukul/getting-started:part2
    deploy:
      replicas: 5
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
  visualizer:
    image: alexellis2/visualizer-arm:latest
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
        - webnet
  redis:
    image: hypriot/rpi-redis:latest
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
