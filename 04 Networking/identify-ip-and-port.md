# Networking > Identify ​​which ​​IP​​ and​​ port​​ a ​​container ​​is ​​externally ​​accessible​​ on

[Back](./ReadMe.md)

docker port
===========

Description[](https://docs.docker.com/engine/reference/commandline/port/#examples#description)
----------------------------------------------------------------------------------------------

List port mappings or a specific mapping for the container

Usage[](https://docs.docker.com/engine/reference/commandline/port/#examples#usage)
----------------------------------------------------------------------------------

```
docker port CONTAINER [PRIVATE_PORT[/PROTO]]

```

Parent command[](https://docs.docker.com/engine/reference/commandline/port/#examples#parent-command)
----------------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker](https://docs.docker.com/engine/reference/commandline/docker) | The base command for the Docker CLI. |

Examples[](https://docs.docker.com/engine/reference/commandline/port/#examples#examples)
----------------------------------------------------------------------------------------

### Show all mapped ports[](https://docs.docker.com/engine/reference/commandline/port/#examples#show-all-mapped-ports)

You can find out all the ports mapped by not specifying a `PRIVATE_PORT`, or just a specific mapping:

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                            NAMES
b650456536c7        busybox:latest      top                 54 minutes ago      Up 54 minutes       0.0.0.0:1234->9876/tcp, 0.0.0.0:4321->7890/tcp   test
$ docker port test
7890/tcp -> 0.0.0.0:4321
9876/tcp -> 0.0.0.0:1234
$ docker port test 7890/tcp
0.0.0.0:4321
$ docker port test 7890/udp
2014/06/24 11:53:36 Error: No public port '7890/udp' published for test
$ docker port test 7890
0.0.0.0:4321
```