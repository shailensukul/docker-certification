# Docker PlayGround

[Docker ARM64 nightly tags](https://hub.docker.com/_/microsoft-dotnet-core-nightly-sdk/)
[Docker Reference](https://docs.docker.com/v17.09/engine/reference/builder)

[Docker Examples](https://docs.docker.com/v17.09/engine/examples/)

## Usage

```
docker build -f DockerFile01 .
```

```
docker run ubuntu
```

## 02
Example from: [official site](https://github.com/dotnet/dotnet-docker/tree/master/samples/aspnetapp)
```
dotnet new webApp -o 02 --no-https
cd 02
```

### Build .NetCore 3

```
docker build -t shailensukul/aspnetcore:1.0.0 -f DockerFile .

docker image ls

docker run -d -p 8080:80 --name myapp shailensukul/aspnetcore:1.0.0

docker container rm myapp
```

### Push image

```

docker push shailensukul/aspnetcore:1.0.0
```

## Run this image on a Pi (AMD64 image)

```
docker run -d -p 80:80 --name myapp shailensukul/aspnetcore:amd64
```