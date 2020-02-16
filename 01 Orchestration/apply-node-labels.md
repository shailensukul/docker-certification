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

The labels you set for nodes using docker node update apply only to the node entity within the swarm. Do not confuse them with the docker daemon labels for dockerd.
