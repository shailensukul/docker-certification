# Storage and Volumes > Demonstrate​​ how​​ storage​ ​can​​ be ​​used ​​across​ ​cluster​ ​nodes

[Back](./ReadMe.md)

Use Docker Engine plugins[🔗](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#use-docker-engine-plugins)
=============================================================================================================================

This document describes the Docker Engine plugins generally available in Docker Engine. To view information on plugins managed by Docker, refer to [Docker Engine plugin system](https://docs.docker.com/engine/extend/).

You can extend the capabilities of the Docker Engine by loading third-party plugins. This page explains the types of plugins and provides links to several volume and network plugins for Docker.

Types of plugins[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#types-of-plugins)
---------------------------------------------------------------------------------------------------------

Plugins extend Docker's functionality. They come in specific types. For example, a [volume plugin](https://docs.docker.com/engine/extend/plugins_volume/) might enable Docker volumes to persist across multiple Docker hosts and a [network plugin](https://docs.docker.com/engine/extend/plugins_network/) might provide network plumbing.

Currently Docker supports authorization, volume and network driver plugins. In the future it will support additional plugin types.

Installing a plugin[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#installing-a-plugin)
---------------------------------------------------------------------------------------------------------------

Follow the instructions in the plugin's documentation.

Finding a plugin[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#finding-a-plugin)
---------------------------------------------------------------------------------------------------------

The sections below provide an inexhaustive overview of available plugins.

### Network plugins[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#network-plugins)

| Plugin | Description |
| --- | --- |
| [Contiv Networking](https://github.com/contiv/netplugin) | An open source network plugin to provide infrastructure and security policies for a multi-tenant micro services deployment, while providing an integration to physical network for non-container workload. Contiv Networking implements the remote driver and IPAM APIs available in Docker 1.9 onwards. |
| [Kuryr Network Plugin](https://github.com/openstack/kuryr) | A network plugin is developed as part of the OpenStack Kuryr project and implements the Docker networking (libnetwork) remote driver API by utilizing Neutron, the OpenStack networking service. It includes an IPAM driver as well. |
| [Weave Network Plugin](https://www.weave.works/docs/net/latest/introducing-weave/) | A network plugin that creates a virtual network that connects your Docker containers - across multiple hosts or clouds and enables automatic discovery of applications. Weave networks are resilient, partition tolerant, secure and work in partially connected networks, and other adverse environments - all configured with delightful simplicity. |

### Volume plugins[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#volume-plugins)

| Plugin | Description |
| --- | --- |
| [Azure File Storage plugin](https://github.com/Azure/azurefile-dockervolumedriver) | Lets you mount Microsoft [Azure File Storage](https://azure.microsoft.com/blog/azure-file-storage-now-generally-available/) shares to Docker containers as volumes using the SMB 3.0 protocol. [Learn more](https://azure.microsoft.com/blog/persistent-docker-volumes-with-azure-file-storage/). |
| [BeeGFS Volume Plugin](https://github.com/RedCoolBeans/docker-volume-beegfs) | An open source volume plugin to create persistent volumes in a BeeGFS parallel file system. |
| [Blockbridge plugin](https://github.com/blockbridge/blockbridge-docker-volume) | A volume plugin that provides access to an extensible set of container-based persistent storage options. It supports single and multi-host Docker environments with features that include tenant isolation, automated provisioning, encryption, secure deletion, snapshots and QoS. |
| [Contiv Volume Plugin](https://github.com/contiv/volplugin) | An open source volume plugin that provides multi-tenant, persistent, distributed storage with intent based consumption. It has support for Ceph and NFS. |
| [Convoy plugin](https://github.com/rancher/convoy) | A volume plugin for a variety of storage back-ends including device mapper and NFS. It's a simple standalone executable written in Go and provides the framework to support vendor-specific extensions such as snapshots, backups and restore. |
| [DigitalOcean Block Storage plugin](https://github.com/omallo/docker-volume-plugin-dostorage) | Integrates DigitalOcean's [block storage solution](https://www.digitalocean.com/products/storage/) into the Docker ecosystem by automatically attaching a given block storage volume to a DigitalOcean droplet and making the contents of the volume available to Docker containers running on that droplet. |
| [DRBD plugin](https://www.drbd.org/en/supported-projects/docker) | A volume plugin that provides highly available storage replicated by [DRBD](https://www.drbd.org/). Data written to the docker volume is replicated in a cluster of DRBD nodes. |
| [Flocker plugin](https://github.com/ScatterHQ/flocker) | A volume plugin that provides multi-host portable volumes for Docker, enabling you to run databases and other stateful containers and move them around across a cluster of machines. |
| [Fuxi Volume Plugin](https://github.com/openstack/fuxi) | A volume plugin that is developed as part of the OpenStack Kuryr project and implements the Docker volume plugin API by utilizing Cinder, the OpenStack block storage service. |
| [gce-docker plugin](https://github.com/mcuadros/gce-docker) | A volume plugin able to attach, format and mount Google Compute [persistent-disks](https://cloud.google.com/compute/docs/disks/persistent-disks). |
| [GlusterFS plugin](https://github.com/calavera/docker-volume-glusterfs) | A volume plugin that provides multi-host volumes management for Docker using GlusterFS. |
| [Horcrux Volume Plugin](https://github.com/muthu-r/horcrux) | A volume plugin that allows on-demand, version controlled access to your data. Horcrux is an open-source plugin, written in Go, and supports SCP, [Minio](https://www.minio.io/) and Amazon S3. |
| [HPE 3Par Volume Plugin](https://github.com/hpe-storage/python-hpedockerplugin/) | A volume plugin that supports HPE 3Par and StoreVirtual iSCSI storage arrays. |
| [Infinit volume plugin](https://infinit.sh/documentation/docker/volume-plugin) | A volume plugin that makes it easy to mount and manage Infinit volumes using Docker. |
| [IPFS Volume Plugin](http://github.com/vdemeester/docker-volume-ipfs) | An open source volume plugin that allows using an [ipfs](https://ipfs.io/) filesystem as a volume. |
| [Keywhiz plugin](https://github.com/calavera/docker-volume-keywhiz) | A plugin that provides credentials and secret management using Keywhiz as a central repository. |
| [Local Persist Plugin](https://github.com/CWSpear/local-persist) | A volume plugin that extends the default `local` driver's functionality by allowing you specify a mountpoint anywhere on the host, which enables the files to *always persist*, even if the volume is removed via `docker volume rm`. |
| [NetApp Plugin](https://github.com/NetApp/netappdvp) (nDVP) | A volume plugin that provides direct integration with the Docker ecosystem for the NetApp storage portfolio. The nDVP package supports the provisioning and management of storage resources from the storage platform to Docker hosts, with a robust framework for adding additional platforms in the future. |
| [Netshare plugin](https://github.com/ContainX/docker-volume-netshare) | A volume plugin that provides volume management for NFS 3/4, AWS EFS and CIFS file systems. |
| [Nimble Storage Volume Plugin](https://connect.nimblestorage.com/community/app-integration/docker) | A volume plug-in that integrates with Nimble Storage Unified Flash Fabric arrays. The plug-in abstracts array volume capabilities to the Docker administrator to allow self-provisioning of secure multi-tenant volumes and clones. |
| [OpenStorage Plugin](https://github.com/libopenstorage/openstorage) | A cluster-aware volume plugin that provides volume management for file and block storage solutions. It implements a vendor neutral specification for implementing extensions such as CoS, encryption, and snapshots. It has example drivers based on FUSE, NFS, NBD and EBS to name a few. |
| [Portworx Volume Plugin](https://github.com/portworx/px-dev) | A volume plugin that turns any server into a scale-out converged compute/storage node, providing container granular storage and highly available volumes across any node, using a shared-nothing storage backend that works with any docker scheduler. |
| [Quobyte Volume Plugin](https://github.com/quobyte/docker-volume) | A volume plugin that connects Docker to [Quobyte](http://www.quobyte.com/containers)'s data center file system, a general-purpose scalable and fault-tolerant storage platform. |
| [REX-Ray plugin](https://github.com/emccode/rexray) | A volume plugin which is written in Go and provides advanced storage functionality for many platforms including VirtualBox, EC2, Google Compute Engine, OpenStack, and EMC. |
| [Virtuozzo Storage and Ploop plugin](https://github.com/virtuozzo/docker-volume-ploop) | A volume plugin with support for Virtuozzo Storage distributed cloud file system as well as ploop devices. |
| [VMware vSphere Storage Plugin](https://github.com/vmware/docker-volume-vsphere) | Docker Volume Driver for vSphere enables customers to address persistent storage requirements for Docker containers in vSphere environments. |

### Authorization plugins[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#authorization-plugins)

| Plugin | Description |
| --- | --- |
| [Casbin AuthZ Plugin](https://github.com/casbin/casbin-authz-plugin) | An authorization plugin based on [Casbin](https://github.com/casbin/casbin), which supports access control models like ACL, RBAC, ABAC. The access control model can be customized. The policy can be persisted into file or DB. |
| [HBM plugin](https://github.com/kassisol/hbm) | An authorization plugin that prevents from executing commands with certains parameters. |
| [Twistlock AuthZ Broker](https://github.com/twistlock/authz) | A basic extendable authorization plugin that runs directly on the host or inside a container. This plugin allows you to define user policies that it evaluates during authorization. Basic authorization is provided if Docker daemon is started with the --tlsverify flag (username is extracted from the certificate common name). |

Troubleshooting a plugin[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#troubleshooting-a-plugin)
-------------------------------------------------------------------------------------------------------------------------

If you are having problems with Docker after loading a plugin, ask the authors of the plugin for help. The Docker team may not be able to assist you.

Writing a plugin[](https://docs.docker.com/engine/extend/legacy_plugins/#volume-plugins#writing-a-plugin)
---------------------------------------------------------------------------------------------------------

If you are interested in writing a plugin for Docker, or seeing how they work under the hood, see the [docker plugins reference](https://docs.docker.com/engine/extend/plugin_api/).
