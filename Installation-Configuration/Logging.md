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