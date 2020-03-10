# Installation-Configuration > Consistently​​ repeat​​ steps ​​to ​​deploy ​​Docker ​​​​engine, ​​UCP, ​​and ​​DTR and Docker ​​on ​​AWS ​​and ​​on premises ​​in ​​an​ ​HA ​​config


[Back](./ReadMe.md)

Universal Control Plane overview
================================

Estimated reading time: 2 minutes

> This topic applies to Docker Enterprise.
>
> The Docker Enterprise platform business, including products, customers, and employees, has been acquired by Mirantis, inc., effective 13-November-2019. For more information on the acquisition and how it may affect you and your business, refer to the [Docker Enterprise Customer FAQ](https://www.docker.com/faq-for-docker-enterprise-customers-and-partners).

Docker Universal Control Plane (UCP) is the enterprise-grade cluster management solution from Docker. You install it on-premises or in your virtual private cloud, and it helps you manage your Docker cluster and applications through a single interface.

![](https://docs.docker.com/ee/ucp/images/v32dashboard.png)

Centralized cluster management[](https://docs.docker.com/ee/ucp/#centralized-cluster-management)
------------------------------------------------------------------------------------------------

With Docker, you can join up to thousands of physical or virtual machines together to create a container cluster that allows you to deploy your applications at scale. UCP extends the functionality provided by Docker to make it easier to manage your cluster from a centralized place.

You can manage and monitor your container cluster using a graphical UI.

![](https://docs.docker.com/ee/ucp/images/v32nodes.png)

Deploy, manage, and monitor[](https://docs.docker.com/ee/ucp/#deploy-manage-and-monitor)
----------------------------------------------------------------------------------------

With UCP, you can manage from a centralized place all of the computing resources you have available, like nodes, volumes, and networks.

You can also deploy and monitor your applications and services.

Built-in security and access control[](https://docs.docker.com/ee/ucp/#built-in-security-and-access-control)
------------------------------------------------------------------------------------------------------------

UCP has its own built-in authentication mechanism and integrates with LDAP services. It also has role-based access control (RBAC), so that you can control who can access and make changes to your cluster and applications. [Learn about role-based access control](https://docs.docker.com/ee/ucp/authorization/).

![](https://docs.docker.com/ee/ucp/images/v32users.png)

UCP integrates with Docker Trusted Registry (DTR) so that you can keep the Docker images you use for your applications behind your firewall, where they are safe and can't be tampered with.

You can also enforce security policies and only allow running applications that use Docker images you know and trust.

Use the Docker CLI client[](https://docs.docker.com/ee/ucp/#use-the-docker-cli-client)
--------------------------------------------------------------------------------------

Because UCP exposes the standard Docker API, you can continue using the tools you already know, including the Docker CLI client, to deploy and manage your applications.

For example, you can use the `docker info` command to check the status of a cluster that's managed by UCP:

```
docker info

```

This command produces the output that you expect from Docker Enterprise:

```
Containers: 38
Running: 23
Paused: 0
Stopped: 15
Images: 17
Server Version: 17.06
...
Swarm: active
NodeID: ocpv7el0uz8g9q7dmw8ay4yps
Is Manager: true
ClusterID: tylpv1kxjtgoik2jnrg8pvkg6
Managers: 1
...
```