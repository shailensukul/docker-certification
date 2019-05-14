# Orchestration > State ​​the ​​differences ​​between​​ an image and a container

[Back](./ReadMe.md)

## What is a Image
An image is a template that can be turned into a container.

1. Docker image is comprised of a series of layers. Each layer is a set of filesystem changes 
and has a unique id upon its creation.
2. Image contains all the data and metadata needed to run the containers that are launched from image.
3. Docker image is an immutable read-only template.

## Image commands

Shows all images
```
docker image ls
```

Builds an image from a Dockerfile
```
docker build
```

Creates a new image from a container's changes, pausing it temporarily if it is running
```
docker commit
```

Remove one or more images
```
docker rmi
```

Tags an image into a repository
```
docker tag
```

Searches Docker Hub for images
```
docker search
```


## Log into a container

docker exec -it [container id] bash

## See the console outout of the container
docker logs -f [container id]

## How to mount the host directory into the new container
docker run -dit -v [local directory]:[directory inside container] [image name]


## How to delete all existing containers
docker rm $(docker ps -qa)