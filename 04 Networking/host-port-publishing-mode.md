# Networking > Describe​​ the ​​difference ​​between ​​"host"​​ and ​"ingress" ​​port​​ > Host

[Back](./ReadMe.md)

### Publish ports[](https://docs.docker.com/engine/swarm/services/#publish-a-services-ports-directly-on-the-swarm-node#publish-ports)

When you create a swarm service, you can publish that service's ports to hosts outside the swarm in two ways:

-   [You can rely on the routing mesh](https://docs.docker.com/engine/swarm/services/#publish-a%20services-ports-using-the-routing-mesh). When you publish a service port, the swarm makes the service accessible at the target port on every node, regardless of whether there is a task for the service running on that node or not. This is less complex and is the right choice for many types of services.

-   [You can publish a service task's port directly on the swarm node](https://docs.docker.com/engine/swarm/services/#publish-a-services-ports-directly-on-the-swarm-node) where that service is running. This feature is available in Docker 1.13 and higher. This bypasses the routing mesh and provides the maximum flexibility, including the ability for you to develop your own routing framework. However, you are responsible for keeping track of where each task is running and routing requests to the tasks, and load-balancing across the nodes.

Keep reading for more information and use cases for each of these methods.

#### PUBLISH A SERVICE'S PORTS USING THE ROUTING MESH

To publish a service's ports externally to the swarm, use the `--publish <PUBLISHED-PORT>:<SERVICE-PORT>` flag. The swarm makes the service accessible at the published port on every swarm node. If an external host connects to that port on any swarm node, the routing mesh routes it to a task. The external host does not need to know the IP addresses or internally-used ports of the service tasks to interact with the service. When a user or process connects to a service, any worker node running a service task may respond. For more details about swarm service networking, see [Manage swarm service networks](https://docs.docker.com/engine/swarm/networking/).

##### Example: Run a three-task Nginx service on 10-node swarm

Imagine that you have a 10-node swarm, and you deploy an Nginx service running three tasks on a 10-node swarm:

```
$ docker service create --name my_web\
                        --replicas 3\
                        --publish published=8080,target=80\
                        nginx

```

Three tasks run on up to three nodes. You don't need to know which nodes are running the tasks; connecting to port 8080 on any of the 10 nodes connects you to one of the three `nginx` tasks. You can test this using `curl`. The following example assumes that `localhost` is one of the swarm nodes. If this is not the case, or `localhost` does not resolve to an IP address on your host, substitute the host's IP address or resolvable host name.

The HTML output is truncated:

```
$ curl localhost:8080

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...truncated...
</html>

```

Subsequent connections may be routed to the same swarm node or a different one.

#### PUBLISH A SERVICE'S PORTS DIRECTLY ON THE SWARM NODE

Using the routing mesh may not be the right choice for your application if you need to make routing decisions based on application state or you need total control of the process for routing requests to your service's tasks. To publish a service's port directly on the node where it is running, use the `mode=host` option to the `--publish` flag.

> Note: If you publish a service's ports directly on the swarm node using `mode=host` and also set `published=<PORT>` this creates an implicit limitation that you can only run one task for that service on a given swarm node. You can work around this by specifying `published` without a port definition, which causes Docker to assign a random port for each task.
>
> In addition, if you use `mode=host` and you do not use the `--mode=global` flag on `docker service create`, it is difficult to know which nodes are running the service to route work to them.

##### Example: Run an `nginx` web server service on every swarm node

[nginx](https://hub.docker.com/_/nginx/) is an open source reverse proxy, load balancer, HTTP cache, and a web server. If you run nginx as a service using the routing mesh, connecting to the nginx port on any swarm node shows you the web page for (effectively) a random swarm node running the service.

The following example runs nginx as a service on each node in your swarm and exposes nginx port locally on each swarm node.

```
$ docker service create\
  --mode global\
  --publish mode=host,target=80,published=8080\
  --name=nginx\
  nginx:latest

```

You can reach the nginx server on port 8080 of every swarm node. If you add a node to the swarm, a nginx task is started on it. You cannot start another service or container on any swarm node which binds to port 8080.

> Note: This is a naive example. Creating an application-layer routing framework for a multi-tiered service is complex and out of scope for this topic.

### Connect the service to an overlay network[](https://docs.docker.com/engine/swarm/services/#publish-a-services-ports-directly-on-the-swarm-node#connect-the-service-to-an-overlay-network)

You can use overlay networks to connect one or more services within the swarm.

First, create overlay network on a manager node using the `docker network create` command with the `--driver overlay` flag.

```
$ docker network create --driver overlay my-network

```

After you create an overlay network in swarm mode, all manager nodes have access to the network.

You can create a new service and pass the `--network` flag to attach the service to the overlay network:

```
$ docker service create\
  --replicas 3\
  --network my-network\
  --name my-web\
  nginx

```

The swarm extends `my-network` to each node running the service.

You can also connect an existing service to an overlay network using the `--network-add` flag.

```
$ docker service update --network-add my-network my-web

```

To disconnect a running service from a network, use the `--network-rm` flag.

```
$ docker service update --network-rm my-network my-web

```

For more information on overlay networking and service discovery, refer to [Attach services to an overlay network](https://docs.docker.com/engine/swarm/networking/) and [Docker swarm mode overlay network security model](https://docs.docker.com/engine/userguide/networking/overlay-security-model/).