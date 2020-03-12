# Networking > Deploy ​​a ​​service​ ​on ​​a ​​Docker​​ overlay​​ network

[Back](./ReadMe.md)

Use overlay networks
====================

Estimated reading time: 11 minutes

The `overlay` network driver creates a distributed network among multiple Docker daemon hosts. This network sits on top of (overlays) the host-specific networks, allowing containers connected to it (including swarm service containers) to communicate securely when encryption is enabled. Docker transparently handles routing of each packet to and from the correct Docker daemon host and the correct destination container.

When you initialize a swarm or join a Docker host to an existing swarm, two new networks are created on that Docker host:

-   an overlay network called `ingress`, which handles control and data traffic related to swarm services. When you create a swarm service and do not connect it to a user-defined overlay network, it connects to the `ingress` network by default.
-   a bridge network called `docker_gwbridge`, which connects the individual Docker daemon to the other daemons participating in the swarm.

You can create user-defined `overlay` networks using `docker network create`, in the same way that you can create user-defined `bridge` networks. Services or containers can be connected to more than one network at a time. Services or containers can only communicate across networks they are each connected to.

Although you can connect both swarm services and standalone containers to an overlay network, the default behaviors and configuration concerns are different. For that reason, the rest of this topic is divided into operations that apply to all overlay networks, those that apply to swarm service networks, and those that apply to overlay networks used by standalone containers.

Operations for all overlay networks[](https://docs.docker.com/network/overlay/#operations-for-all-overlay-networks)
-------------------------------------------------------------------------------------------------------------------

### Create an overlay network[](https://docs.docker.com/network/overlay/#create-an-overlay-network)

> Prerequisites:
>
> -   Firewall rules for Docker daemons using overlay networks
>
>
>
>     You need the following ports open to traffic to and from each Docker host participating on an overlay network:
>
>
>     -   TCP port 2377 for cluster management communications
>     -   TCP and UDP port 7946 for communication among nodes
>     -   UDP port 4789 for overlay network traffic
> -   Before you can create an overlay network, you need to either initialize your Docker daemon as a swarm manager using `docker swarm init` or join it to an existing swarm using `docker swarm join`. Either of these creates the default `ingress` overlay network which is used by swarm services by default. You need to do this even if you never plan to use swarm services. Afterward, you can create additional user-defined overlay networks.

To create an overlay network for use with swarm services, use a command like the following:

```
$ docker network create -d overlay my-overlay

```

To create an overlay network which can be used by swarm services or standalone containers to communicate with other standalone containers running on other Docker daemons, add the `--attachable` flag:

```
$ docker network create -d overlay --attachable my-attachable-overlay

```

You can specify the IP address range, subnet, gateway, and other options. See `docker network create --help` for details.

### Encrypt traffic on an overlay network[](https://docs.docker.com/network/overlay/#encrypt-traffic-on-an-overlay-network)

All swarm service management traffic is encrypted by default, using the [AES algorithm](https://en.wikipedia.org/wiki/Galois/Counter_Mode) in GCM mode. Manager nodes in the swarm rotate the key used to encrypt gossip data every 12 hours.

To encrypt application data as well, add `--opt encrypted` when creating the overlay network. This enables IPSEC encryption at the level of the vxlan. This encryption imposes a non-negligible performance penalty, so you should test this option before using it in production.

When you enable overlay encryption, Docker creates IPSEC tunnels between all the nodes where tasks are scheduled for services attached to the overlay network. These tunnels also use the AES algorithm in GCM mode and manager nodes automatically rotate the keys every 12 hours.

> Do not attach Windows nodes to encrypted overlay networks.
>
> Overlay network encryption is not supported on Windows. If a Windows node attempts to connect to an encrypted overlay network, no error is detected but the node cannot communicate.

#### SWARM MODE OVERLAY NETWORKS AND STANDALONE CONTAINERS

You can use the overlay network feature with both `--opt encrypted --attachable` and attach unmanaged containers to that network:

```
$ docker network create --opt encrypted --driver overlay --attachable my-attachable-multi-host-network

```

### Customize the default ingress network[](https://docs.docker.com/network/overlay/#customize-the-default-ingress-network)

Most users never need to configure the `ingress` network, but Docker 17.05 and higher allow you to do so. This can be useful if the automatically-chosen subnet conflicts with one that already exists on your network, or you need to customize other low-level network settings such as the MTU.

Customizing the `ingress` network involves removing and recreating it. This is usually done before you create any services in the swarm. If you have existing services which publish ports, those services need to be removed before you can remove the `ingress` network.

During the time that no `ingress` network exists, existing services which do not publish ports continue to function but are not load-balanced. This affects services which publish ports, such as a WordPress service which publishes port 80.

1.  Inspect the `ingress` network using `docker network inspect ingress`, and remove any services whose containers are connected to it. These are services that publish ports, such as a WordPress service which publishes port 80. If all such services are not stopped, the next step fails.

2.  Remove the existing `ingress` network:

    ```
    $ docker network rm ingress

    WARNING! Before removing the routing-mesh network, make sure all the nodes
    in your swarm run the same docker engine version. Otherwise, removal may not
    be effective and functionality of newly created ingress networks will be
    impaired.
    Are you sure you want to continue? [y/N]

    ```

3.  Create a new overlay network using the `--ingress` flag, along with the custom options you want to set. This example sets the MTU to 1200, sets the subnet to `10.11.0.0/16`, and sets the gateway to `10.11.0.2`.

    ```
    $ docker network create\
      --driver overlay\
      --ingress\
      --subnet=10.11.0.0/16\
      --gateway=10.11.0.2\
      --opt com.docker.network.driver.mtu=1200\
      my-ingress

    ```

    > Note: You can name your `ingress` network something other than `ingress`, but you can only have one. An attempt to create a second one fails.

4.  Restart the services that you stopped in the first step.

### Customize the docker_gwbridge interface[](https://docs.docker.com/network/overlay/#customize-the-docker_gwbridge-interface)

The `docker_gwbridge` is a virtual bridge that connects the overlay networks (including the `ingress` network) to an individual Docker daemon's physical network. Docker creates it automatically when you initialize a swarm or join a Docker host to a swarm, but it is not a Docker device. It exists in the kernel of the Docker host. If you need to customize its settings, you must do so before joining the Docker host to the swarm, or after temporarily removing the host from the swarm.

1.  Stop Docker.

2.  Delete the existing `docker_gwbridge` interface.

    ```
    $ sudo ip link set docker_gwbridge down

    $ sudo ip link del dev docker_gwbridge

    ```

3.  Start Docker. Do not join or initialize the swarm.

4.  Create or re-create the `docker_gwbridge` bridge manually with your custom settings, using the `docker network create` command. This example uses the subnet `10.11.0.0/16`. For a full list of customizable options, see [Bridge driver options](https://docs.docker.com/engine/reference/commandline/network_create/#bridge-driver-options).

    ```
    $ docker network create\
    --subnet 10.11.0.0/16\
    --opt com.docker.network.bridge.name=docker_gwbridge\
    --opt com.docker.network.bridge.enable_icc=false\
    --opt com.docker.network.bridge.enable_ip_masquerade=true\
    docker_gwbridge

    ```

5.  Initialize or join the swarm. Since the bridge already exists, Docker does not create it with automatic settings.

Operations for swarm services[](https://docs.docker.com/network/overlay/#operations-for-swarm-services)
-------------------------------------------------------------------------------------------------------

### Publish ports on an overlay network[](https://docs.docker.com/network/overlay/#publish-ports-on-an-overlay-network)

Swarm services connected to the same overlay network effectively expose all ports to each other. For a port to be accessible outside of the service, that port must be *published* using the `-p` or `--publish` flag on `docker service create` or `docker service update`. Both the legacy colon-separated syntax and the newer comma-separated value syntax are supported. The longer syntax is preferred because it is somewhat self-documenting.

| Flag value | Description |
| --- | --- |
| `-p 8080:80` or\
`-p published=8080,target=80` | Map TCP port 80 on the service to port 8080 on the routing mesh. |
| `-p 8080:80/udp` or\
`-p published=8080,target=80,protocol=udp` | Map UDP port 80 on the service to port 8080 on the routing mesh. |
| `-p 8080:80/tcp -p 8080:80/udp` or\
`-p published=8080,target=80,protocol=tcp -p published=8080,target=80,protocol=udp` | Map TCP port 80 on the service to TCP port 8080 on the routing mesh, and map UDP port 80 on the service to UDP port 8080 on the routing mesh. |

### Bypass the routing mesh for a swarm service[](https://docs.docker.com/network/overlay/#bypass-the-routing-mesh-for-a-swarm-service)

By default, swarm services which publish ports do so using the routing mesh. When you connect to a published port on any swarm node (whether it is running a given service or not), you are redirected to a worker which is running that service, transparently. Effectively, Docker acts as a load balancer for your swarm services. Services using the routing mesh are running in *virtual IP (VIP) mode*. Even a service running on each node (by means of the `--mode global` flag) uses the routing mesh. When using the routing mesh, there is no guarantee about which Docker node services client requests.

To bypass the routing mesh, you can start a service using *DNS Round Robin (DNSRR) mode*, by setting the `--endpoint-mode` flag to `dnsrr`. You must run your own load balancer in front of the service. A DNS query for the service name on the Docker host returns a list of IP addresses for the nodes running the service. Configure your load balancer to consume this list and balance the traffic across the nodes.

### Separate control and data traffic[](https://docs.docker.com/network/overlay/#separate-control-and-data-traffic)

By default, control traffic relating to swarm management and traffic to and from your applications runs over the same network, though the swarm control traffic is encrypted. You can configure Docker to use separate network interfaces for handling the two different types of traffic. When you initialize or join the swarm, specify `--advertise-addr` and `--datapath-addr` separately. You must do this for each node joining the swarm.

Operations for standalone containers on overlay networks[](https://docs.docker.com/network/overlay/#operations-for-standalone-containers-on-overlay-networks)
-------------------------------------------------------------------------------------------------------------------------------------------------------------

### Attach a standalone container to an overlay network[](https://docs.docker.com/network/overlay/#attach-a-standalone-container-to-an-overlay-network)

The `ingress` network is created without the `--attachable` flag, which means that only swarm services can use it, and not standalone containers. You can connect standalone containers to user-defined overlay networks which are created with the `--attachable` flag. This gives standalone containers running on different Docker daemons the ability to communicate without the need to set up routing on the individual Docker daemon hosts.

### Publish ports[](https://docs.docker.com/network/overlay/#publish-ports)

| Flag value | Description |
| --- | --- |
| `-p 8080:80` | Map TCP port 80 in the container to port 8080 on the overlay network. |
| `-p 8080:80/udp` | Map UDP port 80 in the container to port 8080 on the overlay network. |
| `-p 8080:80/sctp` | Map SCTP port 80 in the container to port 8080 on the overlay network. |
| `-p 8080:80/tcp -p 8080:80/udp` | Map TCP port 80 in the container to TCP port 8080 on the overlay network, and map UDP port 80 in the container to UDP port 8080 on the overlay network. |

### Container discovery[](https://docs.docker.com/network/overlay/#container-discovery)

For most situations, you should connect to the service name, which is load-balanced and handled by all containers ("tasks") backing the service. To get a list of all tasks backing the service, do a DNS lookup for `tasks.<service-name>.`

# Tutorial

Networking with overlay networks
================================

Estimated reading time: 21 minutes

This series of tutorials deals with networking for swarm services. For networking with standalone containers, see [Networking with standalone containers](https://docs.docker.com/network/network-tutorial-standalone/). If you need to learn more about Docker networking in general, see the [overview](https://docs.docker.com/network/).

This topic includes four different tutorials. You can run each of them on Linux, Windows, or a Mac, but for the last two, you need a second Docker host running elsewhere.

-   [Use the default overlay network](https://docs.docker.com/network/network-tutorial-overlay/#use-the-default-overlay-network) demonstrates how to use the default overlay network that Docker sets up for you automatically when you initialize or join a swarm. This network is not the best choice for production systems.

-   [Use user-defined overlay networks](https://docs.docker.com/network/network-tutorial-overlay/#use-a-user-defined-overlay-network) shows how to create and use your own custom overlay networks, to connect services. This is recommended for services running in production.

-   [Use an overlay network for standalone containers](https://docs.docker.com/network/network-tutorial-overlay/#use-an-overlay-network-for-standalone-containers) shows how to communicate between standalone containers on different Docker daemons using an overlay network.

-   [Communicate between a container and a swarm service](https://docs.docker.com/network/network-tutorial-overlay/#communicate-between-a-container-and-a-swarm-service) sets up communication between a standalone container and a swarm service, using an attachable overlay network. This is supported in Docker 17.06 and higher.

Prerequisites[](https://docs.docker.com/network/network-tutorial-overlay/#prerequisites)
----------------------------------------------------------------------------------------

These requires you to have at least a single-node swarm, which means that you have started Docker and run `docker swarm init` on the host. You can run the examples on a multi-node swarm as well.

The last example requires Docker 17.06 or higher.

Use the default overlay network[](https://docs.docker.com/network/network-tutorial-overlay/#use-the-default-overlay-network)
----------------------------------------------------------------------------------------------------------------------------

In this example, you start an `alpine` service and examine the characteristics of the network from the point of view of the individual service containers.

This tutorial does not go into operation-system-specific details about how overlay networks are implemented, but focuses on how the overlay functions from the point of view of a service.

### Prerequisites[](https://docs.docker.com/network/network-tutorial-overlay/#prerequisites-1)

This tutorial requires three physical or virtual Docker hosts which can all communicate with one another, all running new installations of Docker 17.03 or higher. This tutorial assumes that the three hosts are running on the same network with no firewall involved.

These hosts will be referred to as `manager`, `worker-1`, and `worker-2`. The `manager` host will function as both a manager and a worker, which means it can both run service tasks and manage the swarm. `worker-1` and `worker-2` will function as workers only,

If you don't have three hosts handy, an easy solution is to set up three Ubuntu hosts on a cloud provider such as Amazon EC2, all on the same network with all communications allowed to all hosts on that network (using a mechanism such as EC2 security groups), and then to follow the [installation instructions for Docker Engine - Community on Ubuntu](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/).

### Walkthrough[](https://docs.docker.com/network/network-tutorial-overlay/#walkthrough)

#### CREATE THE SWARM

At the end of this procedure, all three Docker hosts will be joined to the swarm and will be connected together using an overlay network called `ingress`.

1.  On `manager`. initialize the swarm. If the host only has one network interface, the `--advertise-addr` flag is optional.

    ```
    $ docker swarm init --advertise-addr=<IP-ADDRESS-OF-MANAGER>

    ```

    Make a note of the text that is printed, as this contains the token that you will use to join `worker-1` and `worker-2` to the swarm. It is a good idea to store the token in a password manager.

2.  On `worker-1`, join the swarm. If the host only has one network interface, the `--advertise-addr` flag is optional.

    ```
    $ docker swarm join --token <TOKEN>\
      --advertise-addr <IP-ADDRESS-OF-WORKER-1>\
      <IP-ADDRESS-OF-MANAGER>:2377

    ```

3.  On `worker-2`, join the swarm. If the host only has one network interface, the `--advertise-addr` flag is optional.

    ```
    $ docker swarm join --token <TOKEN>\
      --advertise-addr <IP-ADDRESS-OF-WORKER-2>\
      <IP-ADDRESS-OF-MANAGER>:2377

    ```

4.  On `manager`, list all the nodes. This command can only be done from a manager.

    ```
    $ docker node ls

    ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
    d68ace5iraw6whp7llvgjpu48 *   ip-172-31-34-146    Ready               Active              Leader
    nvp5rwavvb8lhdggo8fcf7plg     ip-172-31-35-151    Ready               Active
    ouvx2l7qfcxisoyms8mtkgahw     ip-172-31-36-89     Ready               Active

    ```

    You can also use the `--filter` flag to filter by role:

    ```
    $ docker node ls --filter role=manager

    ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
    d68ace5iraw6whp7llvgjpu48 *   ip-172-31-34-146    Ready               Active              Leader

    $ docker node ls --filter role=worker

    ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
    nvp5rwavvb8lhdggo8fcf7plg     ip-172-31-35-151    Ready               Active
    ouvx2l7qfcxisoyms8mtkgahw     ip-172-31-36-89     Ready               Active

    ```

5.  List the Docker networks on `manager`, `worker-1`, and `worker-2` and notice that each of them now has an overlay network called `ingress` and a bridge network called `docker_gwbridge`. Only the listing for `manager` is shown here:

    ```
    $ docker network ls

    NETWORK ID          NAME                DRIVER              SCOPE
    495c570066be        bridge              bridge              local
    961c6cae9945        docker_gwbridge     bridge              local
    ff35ceda3643        host                host                local
    trtnl4tqnc3n        ingress             overlay             swarm
    c8357deec9cb        none                null                local

    ```

The `docker_gwbridge` connects the `ingress` network to the Docker host's network interface so that traffic can flow to and from swarm managers and workers. If you create swarm services and do not specify a network, they are connected to the `ingress` network. It is recommended that you use separate overlay networks for each application or group of applications which will work together. In the next procedure, you will create two overlay networks and connect a service to each of them.

#### CREATE THE SERVICES

1.  On `manager`, create a new overlay network called `nginx-net`:

    ```
    $ docker network create -d overlay nginx-net

    ```

    You don't need to create the overlay network on the other nodes, beacause it will be automatically created when one of those nodes starts running a service task which requires it.

2.  On `manager`, create a 5-replica Nginx service connected to `nginx-net`. The service will publish port 80 to the outside world. All of the service task containers can communicate with each other without opening any ports.

    > Note: Services can only be created on a manager.

    ```
    $ docker service create\
      --name my-nginx\
      --publish target=80,published=80\
      --replicas=5\
      --network nginx-net\
      nginx

    ```

    The default publish mode of `ingress`, which is used when you do not specify a `mode` for the `--publish` flag, means that if you browse to port 80 on `manager`, `worker-1`, or `worker-2`, you will be connected to port 80 on one of the 5 service tasks, even if no tasks are currently running on the node you browse to. If you want to publish the port using `host` mode, you can add `mode=host` to the `--publish` output. However, you should also use `--mode global` instead of `--replicas=5` in this case, since only one service task can bind a given port on a given node.

3.  Run `docker service ls` to monitor the progress of service bring-up, which may take a few seconds.

4.  Inspect the `nginx-net` network on `manager`, `worker-1`, and `worker-2`. Remember that you did not need to create it manually on `worker-1` and `worker-2` because Docker created it for you. The output will be long, but notice the `Containers` and `Peers` sections. `Containers` lists all service tasks (or standalone containers) connected to the overlay network from that host.

5.  From `manager`, inspect the service using `docker service inspect my-nginx` and notice the information about the ports and endpoints used by the service.

6.  Create a new network `nginx-net-2`, then update the service to use this network instead of `nginx-net`:

    ```
    $ docker network create -d overlay nginx-net-2

    ```

    ```
    $ docker service update\
      --network-add nginx-net-2\
      --network-rm nginx-net\
      my-nginx

    ```

7.  Run `docker service ls` to verify that the service has been updated and all tasks have been redeployed. Run `docker network inspect nginx-net` to verify that no containers are connected to it. Run the same command for `nginx-net-2` and notice that all the service task containers are connected to it.

    > Note: Even though overlay networks are automatically created on swarm worker nodes as needed, they are not automatically removed.

8.  Clean up the service and the networks. From `manager`, run the following commands. The manager will direct the workers to remove the networks automatically.

    ```
    $ docker service rm my-nginx
    $ docker network rm nginx-net nginx-net-2

    ```

Use a user-defined overlay network[](https://docs.docker.com/network/network-tutorial-overlay/#use-a-user-defined-overlay-network)
----------------------------------------------------------------------------------------------------------------------------------

### Prerequisites[](https://docs.docker.com/network/network-tutorial-overlay/#prerequisites-2)

This tutorial assumes the swarm is already set up and you are on a manager.

### Walkthrough[](https://docs.docker.com/network/network-tutorial-overlay/#walkthrough-1)

1.  Create the user-defined overlay network.

    ```
    $ docker network create -d overlay my-overlay

    ```

2.  Start a service using the overlay network and publishing port 80 to port 8080 on the Docker host.

    ```
    $ docker service create\
      --name my-nginx\
      --network my-overlay\
      --replicas 1\
      --publish published=8080,target=80\
      nginx:latest

    ```

3.  Run `docker network inspect my-overlay` and verify that the `my-nginx` service task is connected to it, by looking at the `Containers` section.

4.  Remove the service and the network.

    ```
    $ docker service rm my-nginx

    $ docker network rm my-overlay

    ```

Use an overlay network for standalone containers[](https://docs.docker.com/network/network-tutorial-overlay/#use-an-overlay-network-for-standalone-containers)
--------------------------------------------------------------------------------------------------------------------------------------------------------------

This example demonstrates DNS container discovery -- specifically, how to communicate between standalone containers on different Docker daemons using an overlay network. Steps are:

-   On `host1`, initialize the node as a swarm (manager).
-   On `host2`, join the node to the swarm (worker).
-   On `host1`, create an attachable overlay network (`test-net`).
-   On `host1`, run an interactive [alpine](https://hub.docker.com/_/alpine/) container (`alpine1`) on `test-net`.
-   On `host2`, run an interactive, and detached, [alpine](https://hub.docker.com/_/alpine/) container (`alpine2`) on `test-net`.
-   On `host1`, from within a session of `alpine1`, ping `alpine2`.

### Prerequisites[](https://docs.docker.com/network/network-tutorial-overlay/#prerequisites-3)

For this test, you need two different Docker hosts that can communicate with each other. Each host must have Docker 17.06 or higher with the following ports open between the two Docker hosts:

-   TCP port 2377
-   TCP and UDP port 7946
-   UDP port 4789

One easy way to set this up is to have two VMs (either local or on a cloud provider like AWS), each with Docker installed and running. If you're using AWS or a similar cloud computing platform, the easiest configuration is to use a security group that opens all incoming ports between the two hosts and the SSH port from your client's IP address.

This example refers to the two nodes in our swarm as `host1` and `host2`. This example also uses Linux hosts, but the same commands work on Windows.

### Walk-through[](https://docs.docker.com/network/network-tutorial-overlay/#walk-through)

1.  Set up the swarm.

    a. On `host1`, initialize a swarm (and if prompted, use `--advertise-addr` to specify the IP address for the interface that communicates with other hosts in the swarm, for instance, the private IP address on AWS):

    ```
    $ docker swarm init
    Swarm initialized: current node (vz1mm9am11qcmo979tlrlox42) is now a manager.

    To add a worker to this swarm, run the following command:

        docker swarm join --token SWMTKN-1-5g90q48weqrtqryq4kj6ow0e8xm9wmv9o6vgqc5j320ymybd5c-8ex8j0bc40s6hgvy5ui5gl4gy 172.31.47.252:2377

    To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

    ```

    b. On `host2`, join the swarm as instructed above:

    ```
    $ docker swarm join --token <your_token> <your_ip_address>:2377
    This node joined a swarm as a worker.

    ```

    If the node fails to join the swarm, the `docker swarm join` command times out. To resolve, run `docker swarm leave --force` on `host2`, verify your network and firewall settings, and try again.

2.  On `host1`, create an attachable overlay network called `test-net`:

    ```
    $ docker network create --driver=overlay --attachable test-net
    uqsof8phj3ak0rq9k86zta6ht

    ```

    > Notice the returned NETWORK ID -- you will see it again when you connect to it from `host2`.

3.  On `host1`, start an interactive (`-it`) container (`alpine1`) that connects to `test-net`:

    ```
    $ docker run -it --name alpine1 --network test-net alpine
    / #

    ```

4.  On `host2`, list the available networks -- notice that `test-net` does not yet exist:

    ```
    $ docker network ls
    NETWORK ID          NAME                DRIVER              SCOPE
    ec299350b504        bridge              bridge              local
    66e77d0d0e9a        docker_gwbridge     bridge              local
    9f6ae26ccb82        host                host                local
    omvdxqrda80z        ingress             overlay             swarm
    b65c952a4b2b        none                null                local

    ```

5.  On `host2`, start a detached (`-d`) and interactive (`-it`) container (`alpine2`) that connects to `test-net`:

    ```
    $ docker run -dit --name alpine2 --network test-net alpine
    fb635f5ece59563e7b8b99556f816d24e6949a5f6a5b1fbd92ca244db17a4342

    ```

    > Automatic DNS container discovery only works with unique container names.

6.  On `host2`, verify that `test-net` was created (and has the same NETWORK ID as `test-net` on `host1`):

    ```
     $ docker network ls
     NETWORK ID          NAME                DRIVER              SCOPE
     ...
     uqsof8phj3ak        test-net            overlay             swarm

    ```

7.  On `host1`, ping `alpine2` within the interactive terminal of `alpine1`:

    ```
    / # ping -c 2 alpine2
    PING alpine2 (10.0.0.5): 56 data bytes
    64 bytes from 10.0.0.5: seq=0 ttl=64 time=0.600 ms
    64 bytes from 10.0.0.5: seq=1 ttl=64 time=0.555 ms

    --- alpine2 ping statistics ---
    2 packets transmitted, 2 packets received, 0% packet loss
    round-trip min/avg/max = 0.555/0.577/0.600 ms

    ```

    The two containers communicate with the overlay network connecting the two hosts. If you run another alpine container on `host2` that is *not detached*, you can ping `alpine1` from `host2` (and here we add the [remove option](https://docs.docker.com/engine/reference/run/#clean-up---rm) for automatic container cleanup):

    ```
    $ docker run -it --rm --name alpine3 --network test-net alpine
    / # ping -c 2 alpine1
    / # exit

    ```

8.  On `host1`, close the `alpine1` session (which also stops the container):

    ```
    / # exit

    ```

9.  Clean up your containers and networks:

    You must stop and remove the containers on each host independently because Docker daemons operate independently and these are standalone containers. You only have to remove the network on `host1` because when you stop `alpine2` on `host2`, `test-net` disappears.

    a. On `host2`, stop `alpine2`, check that `test-net` was removed, then remove `alpine2`:

    ```
    $ docker container stop alpine2
    $ docker network ls
    $ docker container rm alpine2

    ```

    a. On `host1`, remove `alpine1` and `test-net`:

    ```
    $ docker container rm alpine1
    $ docker network rm test-net

    ```

Communicate between a container and a swarm service[](https://docs.docker.com/network/network-tutorial-overlay/#communicate-between-a-container-and-a-swarm-service)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Prerequisites[](https://docs.docker.com/network/network-tutorial-overlay/#prerequisites-4)

You need Docker 17.06 or higher for this example.

### Walkthrough[](https://docs.docker.com/network/network-tutorial-overlay/#walkthrough-2)

In this example, you start two different `alpine` containers on the same Docker host and do some tests to understand how they communicate with each other. You need to have Docker installed and running.

1.  Open a terminal window. List current networks before you do anything else. Here's what you should see if you've never added a network or initialized a swarm on this Docker daemon. You may see different networks, but you should at least see these (the network IDs will be different):

    ```
    $ docker network ls

    NETWORK ID          NAME                DRIVER              SCOPE
    17e324f45964        bridge              bridge              local
    6ed54d316334        host                host                local
    7092879f2cc8        none                null                local

    ```

    The default `bridge` network is listed, along with `host` and `none`. The latter two are not fully-fledged networks, but are used to start a container connected directly to the Docker daemon host's networking stack, or to start a container with no network devices. This tutorial will connect two containers to the `bridge` network.

2.  Start two `alpine` containers running `ash`, which is Alpine's default shell rather than `bash`. The `-dit` flags mean to start the container detached (in the background), interactive (with the ability to type into it), and with a TTY (so you can see the input and output). Since you are starting it detached, you won't be connected to the container right away. Instead, the container's ID will be printed. Because you have not specified any `--network` flags, the containers connect to the default `bridge` network.

    ```
    $ docker run -dit --name alpine1 alpine ash

    $ docker run -dit --name alpine2 alpine ash

    ```

    Check that both containers are actually started:

    ```
    $ docker container ls

    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    602dbf1edc81        alpine              "ash"               4 seconds ago       Up 3 seconds                            alpine2
    da33b7aa74b0        alpine              "ash"               17 seconds ago      Up 16 seconds                           alpine1

    ```

3.  Inspect the `bridge` network to see what containers are connected to it.

    ```
    $ docker network inspect bridge

    [
        {
            "Name": "bridge",
            "Id": "17e324f459648a9baaea32b248d3884da102dde19396c25b30ec800068ce6b10",
            "Created": "2017-06-22T20:27:43.826654485Z",
            "Scope": "local",
            "Driver": "bridge",
            "EnableIPv6": false,
            "IPAM": {
                "Driver": "default",
                "Options": null,
                "Config": [
                    {
                        "Subnet": "172.17.0.0/16",
                        "Gateway": "172.17.0.1"
                    }
                ]
            },
            "Internal": false,
            "Attachable": false,
            "Containers": {
                "602dbf1edc81813304b6cf0a647e65333dc6fe6ee6ed572dc0f686a3307c6a2c": {
                    "Name": "alpine2",
                    "EndpointID": "03b6aafb7ca4d7e531e292901b43719c0e34cc7eef565b38a6bf84acf50f38cd",
                    "MacAddress": "02:42:ac:11:00:03",
                    "IPv4Address": "172.17.0.3/16",
                    "IPv6Address": ""
                },
                "da33b7aa74b0bf3bda3ebd502d404320ca112a268aafe05b4851d1e3312ed168": {
                    "Name": "alpine1",
                    "EndpointID": "46c044a645d6afc42ddd7857d19e9dcfb89ad790afb5c239a35ac0af5e8a5bc5",
                    "MacAddress": "02:42:ac:11:00:02",
                    "IPv4Address": "172.17.0.2/16",
                    "IPv6Address": ""
                }
            },
            "Options": {
                "com.docker.network.bridge.default_bridge": "true",
                "com.docker.network.bridge.enable_icc": "true",
                "com.docker.network.bridge.enable_ip_masquerade": "true",
                "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
                "com.docker.network.bridge.name": "docker0",
                "com.docker.network.driver.mtu": "1500"
            },
            "Labels": {}
        }
    ]

    ```

    Near the top, information about the `bridge` network is listed, including the IP address of the gateway between the Docker host and the `bridge` network (`172.17.0.1`). Under the `Containers` key, each connected container is listed, along with information about its IP address (`172.17.0.2` for `alpine1` and `172.17.0.3` for `alpine2`).

4.  The containers are running in the background. Use the `docker attach` command to connect to `alpine1`.

    ```
    $ docker attach alpine1

    / #

    ```

    The prompt changes to `#` to indicate that you are the `root` user within the container. Use the `ip addr show` command to show the network interfaces for `alpine1` as they look from within the container:

    ```
    # ip addr show

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    27: eth0@if28: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP
        link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
        inet 172.17.0.2/16 scope global eth0
           valid_lft forever preferred_lft forever
        inet6 fe80::42:acff:fe11:2/64 scope link
           valid_lft forever preferred_lft forever

    ```

    The first interface is the loopback device. Ignore it for now. Notice that the second interface has the IP address `172.17.0.2`, which is the same address shown for `alpine1` in the previous step.

5.  From within `alpine1`, make sure you can connect to the internet by pinging `google.com`. The `-c 2` flag limits the command two two `ping` attempts.

    ```
    # ping -c 2 google.com

    PING google.com (172.217.3.174): 56 data bytes
    64 bytes from 172.217.3.174: seq=0 ttl=41 time=9.841 ms
    64 bytes from 172.217.3.174: seq=1 ttl=41 time=9.897 ms

    --- google.com ping statistics ---
    2 packets transmitted, 2 packets received, 0% packet loss
    round-trip min/avg/max = 9.841/9.869/9.897 ms

    ```

6.  Now try to ping the second container. First, ping it by its IP address, `172.17.0.3`:

    ```
    # ping -c 2 172.17.0.3

    PING 172.17.0.3 (172.17.0.3): 56 data bytes
    64 bytes from 172.17.0.3: seq=0 ttl=64 time=0.086 ms
    64 bytes from 172.17.0.3: seq=1 ttl=64 time=0.094 ms

    --- 172.17.0.3 ping statistics ---
    2 packets transmitted, 2 packets received, 0% packet loss
    round-trip min/avg/max = 0.086/0.090/0.094 ms

    ```

    This succeeds. Next, try pinging the `alpine2` container by container name. This will fail.

    ```
    # ping -c 2 alpine2

    ping: bad address 'alpine2'

    ```

7.  Detach from `alpine1` without stopping it by using the detach sequence, `CTRL` + `p` `CTRL` + `q` (hold down `CTRL` and type `p` followed by `q`). If you wish, attach to `alpine2` and repeat steps 4, 5, and 6 there, substituting `alpine1` for `alpine2`.

8.  Stop and remove both containers.

    ```
    $ docker container stop alpine1 alpine2
    $ docker container rm alpine1 alpine2

    ```

Remember, the default `bridge` network is not recommended for production. To learn about user-defined bridge networks, continue to the [next tutorial](https://docs.docker.com/network/network-tutorial-overlay/#use-user-defined-bridge-networks).