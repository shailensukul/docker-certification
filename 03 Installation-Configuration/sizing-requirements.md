# Installation-Configuration > Outline ​​the​​ sizing​​ requirements ​​prior ​​to ​​installation

[Back](./ReadMe.md)

UCP System requirements
=======================

Estimated reading time: 5 minutes

> The documentation herein is for UCP version 2.2.22.

Docker Universal Control Plane can be installed on-premises or on the cloud. Before installing, be sure your infrastructure has these requirements.

Hardware and software requirements[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/system-requirements/#hardware-and-software-requirements#hardware-and-software-requirements)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

You can install UCP on-premises or on a cloud provider. Common requirements:

-   [Docker Enterprise Edition](https://docs.docker.com/install/) version 17.06 or higher
-   Linux kernel version 3.10 or higher
-   A static IP address

### Minimum requirements[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/system-requirements/#hardware-and-software-requirements#minimum-requirements)

-   8GB of RAM for manager nodes or nodes running DTR
-   4GB of RAM for worker nodes
-   3GB of free disk space

### Recommended production requirements[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/system-requirements/#hardware-and-software-requirements#recommended-production-requirements)

-   16GB of RAM for manager nodes or nodes running DTR
-   4 vCPUs for manager nodes or nodes running DTR
-   25-100GB of free disk space

Windows container images are typically larger than Linux ones and for that reason, you should consider provisioning more local storage for Windows nodes and for DTR setups that will store Windows container images.

When planning for host storage, workflows based around `docker pull` through UCP will result in higher storage requirements on manager nodes, since `docker pull` through UCP results in the image being pulled on all nodes.

Also, make sure the nodes are running an [operating system support by Docker Enterprise](https://success.docker.com/Policies/Compatibility_Matrix).

For highly-available installations, you also need a way to transfer files between hosts.

> Workloads on manager nodes
>
> These requirements assume that manager nodes don't run regular workloads. If you plan to run additional workloads on manager nodes, you may need to provision more powerful nodes. If manager nodes become overloaded, the swarm may experience issues.

Ports used[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/system-requirements/#hardware-and-software-requirements#ports-used)
------------------------------------------------------------------------------------------------------------------------------------------------

When installing UCP on a host, make sure the following ports are open:

| Hosts | Direction | Port | Purpose |
| --- | --- | --- | --- |
| managers, workers | in | TCP 443 (configurable) | Port for the UCP web UI and API |
| managers | in | TCP 2376 (configurable) | Port for the Docker Swarm manager. Used for backwards compatibility |
| managers, workers | in | TCP 2377 (configurable) | Port for communication between swarm nodes |
| workers | out | TCP 2377 (configurable) | Port for communication between swarm nodes |
| managers, workers | in, out | UDP 4789 | Port for overlay networking |
| managers, workers | in, out | TCP, UDP 7946 | Port for gossip-based clustering |
| managers, workers | in | TCP 12376 | Port for a TLS proxy that provides access to UCP, Docker Engine, and Docker Swarm |
| managers | in | TCP 12379 | Port for internal node configuration, cluster configuration, and HA |
| managers | in | TCP 12380 | Port for internal node configuration, cluster configuration, and HA |
| managers | in | TCP 12381 | Port for the certificate authority |
| managers | in | TCP 12382 | Port for the UCP certificate authority |
| managers | in | TCP 12383 | Port for the authentication storage backend |
| managers | in | TCP 12384 | Port for the authentication storage backend for replication across managers |
| managers | in | TCP 12385 | Port for the authentication service API |
| managers | in | TCP 12386 | Port for the authentication worker |
| managers | in | TCP 12387 | Port for the metrics service |

For overlay networks with encryption to work, you need to ensure that IP protocol 50 (ESP) traffic is allowed.

Also, make sure the networks you're using allow the UCP components enough time to communicate before they time out.

| Component | Timeout (ms) | Configurable |
| --- | --- | --- |
| Raft consensus between manager nodes | 3000 | no |
| Gossip protocol for overlay networking | 5000 | no |
| etcd | 500 | yes |
| RethinkDB | 10000 | no |
| Stand-alone swarm | 90000 | no |

Time synchronization[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/system-requirements/#hardware-and-software-requirements#time-synchronization)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

In distributed systems like Docker UCP, time synchronization is critical to ensure proper operation. As a best practice to ensure consistency between the engines in a UCP swarm, all engines should regularly synchronize time with a Network Time Protocol (NTP) server. If a server's clock is skewed, unexpected behavior may cause poor performance or even failures.

Compatibility and maintenance lifecycle[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/system-requirements/#hardware-and-software-requirements#compatibility-and-maintenance-lifecycle)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Docker Enterprise is a software subscription that includes three products:

-   Docker Engine with enterprise-grade support,
-   Docker Trusted Registry,
-   Docker Universal Control Plane.

Learn more about compatibility and the maintenance lifecycle for these products:

-   [Compatibility Matrix](https://success.docker.com/Policies/Compatibility_Matrix)
-   [Maintenance Lifecycle](https://success.docker.com/Policies/Maintenance_Lifecycle)

Version compatibility[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/system-requirements/#hardware-and-software-requirements#version-compatibility)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

UCP 2.2 requires minimum versions of the following Docker components:

-   Docker Engine 17.06 or higher
-   DTR 2.3 or higher