# Image Creation, Management and Registry > Inspect ​​images ​​and ​​report​​ specific​​ attributes ​​using ​​filter ​​and ​​format

[Back](./ReadMe.md)

docker inspect
==============

Description[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#description)
-------------------------------------------------------------------------------------------------------------

Return low-level information on Docker objects

Usage[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#usage)
-------------------------------------------------------------------------------------------------

```
docker inspect [OPTIONS] NAME|ID [NAME|ID...]

```

Options[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#options)
-----------------------------------------------------------------------------------------------------

| Name, shorthand | Default | Description |
| --- | --- | --- |
| `--format , -f` |  | Format the output using the given Go template |
| `--size , -s` |  | Display total file sizes if the type is container |
| `--type` |  | Return JSON for specified type |

Parent command[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#parent-command)
-------------------------------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker](https://docs.docker.com/engine/reference/commandline/docker) | The base command for the Docker CLI. |

Extended description[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#extended-description)
-------------------------------------------------------------------------------------------------------------------------------

Docker inspect provides detailed information on constructs controlled by Docker.

By default, `docker inspect` will render results in a JSON array.

Examples[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#examples)
-------------------------------------------------------------------------------------------------------

### Get an instance's IP address[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#get-an-instances-ip-address)

For the most part, you can pick out any field from the JSON in a fairly straightforward manner.

```
$ docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $INSTANCE_ID

```

### Get an instance's MAC address[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#get-an-instances-mac-address)

```
$ docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' $INSTANCE_ID

```

### Get an instance's log path[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#get-an-instances-log-path)

```
$ docker inspect --format='{{.LogPath}}' $INSTANCE_ID

```

### Get an instance's image name[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#get-an-instances-image-name)

```
$ docker inspect --format='{{.Config.Image}}' $INSTANCE_ID

```

### List all port bindings[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#list-all-port-bindings)

You can loop over arrays and maps in the results to produce simple text output:

```
$ docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $INSTANCE_ID

```

### Find a specific port mapping[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#find-a-specific-port-mapping)

The `.Field` syntax doesn't work when the field name begins with a number, but the template language's `index` function does. The `.NetworkSettings.Ports` section contains a map of the internal port mappings to a list of external address/port objects. To grab just the numeric public port, you use `index` to find the specific port map, and then `index` 0 contains the first object inside of that. Then we ask for the `HostPort` field to get the public address.

```
$ docker inspect --format='{{(index (index .NetworkSettings.Ports "8787/tcp") 0).HostPort}}' $INSTANCE_ID

```

### Get a subsection in JSON format[](https://docs.docker.com/engine/reference/commandline/inspect/#extended-description#get-a-subsection-in-json-format)

If you request a field which is itself a structure containing other fields, by default you get a Go-style dump of the inner values. Docker adds a template function, `json`, which can be applied to get results in JSON format.

```
$ docker inspect --format='{{json .Config}}' $INSTANCE_ID
```