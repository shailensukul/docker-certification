# Installation-Configuration > Logging

[Back](./ReadMe.md)

[Docker Logs Reference](https://docs.docker.com/engine/reference/commandline/logs)

### Description
Fetch the logs of a container

### Syntax

```
docker logs [OPTIONS] CONTAINER
```

## Options

| Name | Shorthand| Default|	Description |
| --- | --- | --- | --- |
| --details | | | Show extra details provided to logs
| --follow | -f | | Follow log output |
| --since | | | Show logs since timestamp (e.g. 2013-01-02T13:23:37) or relative (e.g. 42m for 42 minutes) |
| --tail | | all | Number of lines to show from the end of the logs |
| --timestamps | -t | | Show timestamps |
| --until | | |	 Show logs before a timestamp (e.g. 2013-01-02T13:23:37) or relative (e.g. 42m for 42 minutes) |

## Logging Drivers

[Reference](https://docs.docker.com/config/containers/logging/configure/)

 Set the value of log-driver to the name of the logging driver in the ```daemon.json``` file. It is located in ```/etc/docker/``` on Linux and ```C:\ProgramData\docker\config\``` on Windows Server.


The default logging driver is ```json-file```

 Example:
 ```
 {
  "log-driver": "syslog"
}
 ``` 

 Example with logging options:
 ```
 {
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "production_status",
    "env": "os,customer"
  }
}
 ```

## Configure the logging driver for a container

When you start a container, you can configure it to use a different logging driver than the Docker daemon’s default, using the ```--log-driver``` flag. 

If the logging driver has configurable options, you can set them using one or more instances of the ```--log-opt <NAME>=<VALUE>``` flag.
 
Example:

```
$ docker run -it --log-driver none alpine ash
```

To find the current container's logging driver:

```
$ docker inspect -f '{{.HostConfig.LogConfig.Type}}' <CONTAINER>

json-file
```