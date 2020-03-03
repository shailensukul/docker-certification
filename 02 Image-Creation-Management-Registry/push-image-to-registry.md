# Image Creation, Management and Registry > Push ​​an ​​image ​​to ​​a ​​registry

[Back](./ReadMe.md)

docker push
===========

Description[](https://docs.docker.com/engine/reference/commandline/push/#description)
-------------------------------------------------------------------------------------

Push an image or a repository to a registry

Usage[](https://docs.docker.com/engine/reference/commandline/push/#usage)
-------------------------------------------------------------------------

```
docker push [OPTIONS] NAME[:TAG]

```

Options[](https://docs.docker.com/engine/reference/commandline/push/#options)
-----------------------------------------------------------------------------

| Name, shorthand | Default | Description |
| --- | --- | --- |
| `--disable-content-trust` | `true` | Skip image signing |

Parent command[](https://docs.docker.com/engine/reference/commandline/push/#parent-command)
-------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker](https://docs.docker.com/engine/reference/commandline/docker) | The base command for the Docker CLI. |

Extended description[](https://docs.docker.com/engine/reference/commandline/push/#extended-description)
-------------------------------------------------------------------------------------------------------

Use `docker push` to share your images to the [Docker Hub](https://hub.docker.com/) registry or to a self-hosted one.

Refer to the [`docker tag`](https://docs.docker.com/engine/reference/commandline/tag/) reference for more information about valid image and tag names.

Killing the `docker push` process, for example by pressing `CTRL-c` while it is running in a terminal, terminates the push operation.

Progress bars are shown during docker push, which show the uncompressed size. The actual amount of data that's pushed will be compressed before sending, so the uploaded size will not be reflected by the progress bar.

Registry credentials are managed by [docker login](https://docs.docker.com/engine/reference/commandline/login/).

### Concurrent uploads[](https://docs.docker.com/engine/reference/commandline/push/#concurrent-uploads)

By default the Docker daemon will push five layers of an image at a time. If you are on a low bandwidth connection this may cause timeout issues and you may want to lower this via the `--max-concurrent-uploads` daemon option. See the [daemon documentation](https://docs.docker.com/engine/reference/commandline/dockerd/) for more details.

Examples[](https://docs.docker.com/engine/reference/commandline/push/#examples)
-------------------------------------------------------------------------------

### Push a new image to a registry[](https://docs.docker.com/engine/reference/commandline/push/#push-a-new-image-to-a-registry)

First save the new image by finding the container ID (using [`docker ps`](https://docs.docker.com/engine/reference/commandline/ps/)) and then committing it to a new image name. Note that only `a-z0-9-_.` are allowed when naming images:

```
$ docker commit c16378f943fe rhel-httpd

```

Now, push the image to the registry using the image ID. In this example the registry is on host named `registry-host` and listening on port `5000`. To do this, tag the image with the host name or IP address, and the port of the registry:

```
$ docker tag rhel-httpd registry-host:5000/myadmin/rhel-httpd

$ docker push registry-host:5000/myadmin/rhel-httpd

```

Check that this worked by running:

```
$ docker images

```

You should see both `rhel-httpd` and `registry-host:5000/myadmin/rhel-httpd` listed.