# Storage and Volumes > Identify​​ the​​ steps ​​you ​​would ​​take ​​to ​​clean​​up ​​unused ​​images​​ on ​​a ​​filesystem,​​ also on DTR > Image Prune

[Back](./ReadMe.md)

docker image prune
==================

Description[](https://docs.docker.com/engine/reference/commandline/image_prune/#description)
--------------------------------------------------------------------------------------------

Remove unused images

[API 1.25+](https://docs.docker.com/engine/api/v1.25/)  The client and daemon API must both be at least [1.25](https://docs.docker.com/engine/api/v1.25/) to use this command. Use the `docker version` command on the client to check your client and daemon API versions.

Usage[](https://docs.docker.com/engine/reference/commandline/image_prune/#usage)
--------------------------------------------------------------------------------

```
docker image prune [OPTIONS]

```

Options[](https://docs.docker.com/engine/reference/commandline/image_prune/#options)
------------------------------------------------------------------------------------

| Name, shorthand | Default | Description |
| --- | --- | --- |
| `--all , -a` |  | Remove all unused images, not just dangling ones |
| `--filter` |  | Provide filter values (e.g. 'until=') |
| `--force , -f` |  | Do not prompt for confirmation |

Parent command[](https://docs.docker.com/engine/reference/commandline/image_prune/#parent-command)
--------------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker image](https://docs.docker.com/engine/reference/commandline/image) | Manage images |