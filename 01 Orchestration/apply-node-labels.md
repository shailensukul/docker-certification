# Orchestration > Apply​ ​node​ ​labels​ ​to​ ​demonstrate​ ​placement​ ​of​ ​tasks

[Back](./ReadMe.md)

## docker node update

```
docker node update [OPTIONS] NODE
```

### Options

* --availability		Availability of the node (“active”|”pause”|”drain”)
* --label-add		Add or update a node label (key=value)
* --label-rm		Remove a node label if exists
* --role		Role of the node (“worker”|”manager”)

### Examples

#### Add label metadata to a node
Add metadata to a swarm node using node labels. You can specify a node label as a key with an empty value:
```
docker node update --label-add foo worker1
```

To add multiple labels to a node, pass the --label-add flag for each label:
```
docker node update --label-add foo --label-add bar worker1
```

When you create a service, you can use node labels as a constraint. A constraint limits the nodes where the scheduler deploys tasks for a service.

For example, to add a type label to identify nodes where the scheduler should deploy message queue service tasks:

```
docker node update --label-add type=queue worker1
```

The labels you set for nodes using docker node update apply only to the node entity within the swarm. Do not confuse them with the docker daemon labels for [dockerd](https://docs.docker.com/engine/userguide/labels-custom-metadata/#daemon-labels).

docker node
===========

Description[](https://docs.docker.com/engine/reference/commandline/node/#description)
-------------------------------------------------------------------------------------

Manage Swarm nodes

[API 1.24+](https://docs.docker.com/engine/api/v1.24/)  The client and daemon API must both be at least [1.24](https://docs.docker.com/engine/api/v1.24/) to use this command. Use the `docker version` command on the client to check your client and daemon API versions.

Swarm This command works with the Swarm orchestrator.

Usage[](https://docs.docker.com/engine/reference/commandline/node/#usage)
-------------------------------------------------------------------------

```
docker node COMMAND

```

Extended description[](https://docs.docker.com/engine/reference/commandline/node/#extended-description)
-------------------------------------------------------------------------------------------------------

Manage nodes.

Parent command[](https://docs.docker.com/engine/reference/commandline/node/#parent-command)
-------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker](https://docs.docker.com/engine/reference/commandline/docker) | The base command for the Docker CLI. |

Child commands[](https://docs.docker.com/engine/reference/commandline/node/#child-commands)
-------------------------------------------------------------------------------------------

| Command | Description |
| --- | --- |
| [docker node demote](https://docs.docker.com/engine/reference/commandline/node_demote/) | Demote one or more nodes from manager in the swarm |
| [docker node inspect](https://docs.docker.com/engine/reference/commandline/node_inspect/) | Display detailed information on one or more nodes |
| [docker node ls](https://docs.docker.com/engine/reference/commandline/node_ls/) | List nodes in the swarm |
| [docker node promote](https://docs.docker.com/engine/reference/commandline/node_promote/) | Promote one or more nodes to manager in the swarm |
| [docker node ps](https://docs.docker.com/engine/reference/commandline/node_ps/) | List tasks running on one or more nodes, defaults to current node |
| [docker node rm](https://docs.docker.com/engine/reference/commandline/node_rm/) | Remove one or more nodes from the swarm |
| [docker node update](https://docs.docker.com/engine/reference/commandline/node_update/) | Update a nod |