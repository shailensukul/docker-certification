# Image Creation, Management and Registry > Display​​ layers​ ​of ​a​ ​Docker ​​image

[Back](./ReadMe.md)

docker image history
====================

Description[](https://docs.docker.com/engine/reference/commandline/image_history/#description)
----------------------------------------------------------------------------------------------

Show the history of an image

Usage[](https://docs.docker.com/engine/reference/commandline/image_history/#usage)
----------------------------------------------------------------------------------

```
docker image history [OPTIONS] IMAGE

```

Options[](https://docs.docker.com/engine/reference/commandline/image_history/#options)
--------------------------------------------------------------------------------------

| Name, shorthand | Default | Description |
| --- | --- | --- |
| `--format` |  | Pretty-print images using a Go template |
| `--human , -H` | `true` | Print sizes and dates in human readable format |
| `--no-trunc` |  | Don't truncate output |
| `--quiet , -q` |  | Only show numeric IDs |

Parent command[](https://docs.docker.com/engine/reference/commandline/image_history/#parent-command)
----------------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker image](https://docs.docker.com/engine/reference/commandline/image) | Manage images |

Related commands[](https://docs.docker.com/engine/reference/commandline/image_history/#related-commands)
--------------------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker image build](https://docs.docker.com/engine/reference/commandline/image_build/) | Build an image from a Dockerfile |
| [docker image history](https://docs.docker.com/engine/reference/commandline/image_history/) | Show the history of an image |
| [docker image import](https://docs.docker.com/engine/reference/commandline/image_import/) | Import the contents from a tarball to create a filesystem image |
| [docker image inspect](https://docs.docker.com/engine/reference/commandline/image_inspect/) | Display detailed information on one or more images |
| [docker image load](https://docs.docker.com/engine/reference/commandline/image_load/) | Load an image from a tar archive or STDIN |
| [docker image ls](https://docs.docker.com/engine/reference/commandline/image_ls/) | List images |
| [docker image prune](https://docs.docker.com/engine/reference/commandline/image_prune/) | Remove unused images |
| [docker image pull](https://docs.docker.com/engine/reference/commandline/image_pull/) | Pull an image or a repository from a registry |
| [docker image push](https://docs.docker.com/engine/reference/commandline/image_push/) | Push an image or a repository to a registry |
| [docker image rm](https://docs.docker.com/engine/reference/commandline/image_rm/) | Remove one or more images |
| [docker image save](https://docs.docker.com/engine/reference/commandline/image_save/) | Save one or more images to a tar archive (streamed to STDOUT by default) |
| [docker image tag](https://docs.docker.com/engine/reference/commandline/image_tag/) | Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE |