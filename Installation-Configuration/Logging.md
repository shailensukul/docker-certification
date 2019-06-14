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

When you start a container, you can configure it to use a different logging driver than the Docker daemon’s default, using the `--log-driver` flag. 

If the logging driver has configurable options, you can set them using one or more instances of the `--log-opt <NAME>=<VALUE>` flag.
 
Example:

```
$ docker run -it --log-driver none alpine ash
```

To find the current container's logging driver:

```
$ docker inspect -f '{{.HostConfig.LogConfig.Type}}' <CONTAINER>

json-file
```

## Configure the delivery mode of log messages from container to log driver

Docker provides two modes for delivering messages from the container to the log driver:

* (default) direct, blocking delivery from container to driver
* non-blocking delivery that stores log messages in an intermediate per-container ring buffer for consumption by driver.
The non-blocking message delivery mode prevents applications from blocking due to logging back pressure.

| Log options | Description |
| --- | --- |
| mode | The mode log option controls whether to use the blocking (default) or non-blocking message delivery. |
| max-buffer-size | The max-buffer-size log option controls the size of the ring buffer used for intermediate message storage when mode is set to non-blocking. max-buffer-size defaults to 1 megabyte.|


Example: 
```
$ docker run -it --log-opt mode=non-blocking --log-opt max-buffer-size=4m alpine ping 127.0.0.1
```
## Supported Logging Drivers

| Driver | Description |
| --- | --- |
| `none` | No logs are available for the container and `docker logs` does not return any output. |
| [`local`](https://docs.docker.com/config/containers/logging/local/) | Logs are stored in a custom format designed for minimal overhead. |
| [`json-file`](https://docs.docker.com/config/containers/logging/json-file/) | The logs are formatted as JSON. The default logging driver for Docker. |
| [`syslog`](https://docs.docker.com/config/containers/logging/syslog/) | Writes logging messages to the `syslog` facility. The `syslog` daemon must be running on the host machine. |
| [`journald`](https://docs.docker.com/config/containers/logging/journald/) | Writes log messages to `journald`. The `journald` daemon must be running on the host machine. |
| [`gelf`](https://docs.docker.com/config/containers/logging/gelf/) | Writes log messages to a Graylog Extended Log Format (GELF) endpoint such as Graylog or Logstash. |
| [`fluentd`](https://docs.docker.com/config/containers/logging/fluentd/) | Writes log messages to `fluentd` (forward input). The `fluentd` daemon must be running on the host machine. |
| [`awslogs`](https://docs.docker.com/config/containers/logging/awslogs/) | Writes log messages to Amazon CloudWatch Logs. |
| [`splunk`](https://docs.docker.com/config/containers/logging/splunk/) | Writes log messages to `splunk` using the HTTP Event Collector. |
| [`etwlogs`](https://docs.docker.com/config/containers/logging/etwlogs/) | Writes log messages as Event Tracing for Windows (ETW) events. Only available on Windows platforms. |
| [`gcplogs`](https://docs.docker.com/config/containers/logging/gcplogs/) | Writes log messages to Google Cloud Platform (GCP) Logging. |
| [`logentries`](https://docs.docker.com/config/containers/logging/logentries/) | Writes log messages to Rapid7 Logentries. |