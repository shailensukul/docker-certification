# Docker PlayGround

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

```

dotnet new webApp -o 02 --no-https
cd 02

Build .NetCore 3

```
docker build -t 02 -f DockerFile0 .

docker run -d -p 8080:80 --name myapp 02

docker container rm myapp
```