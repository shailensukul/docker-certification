# Installation-Configuration > Complete​​ configuration ​​of ​​backups ​​for ​​UCP ​​and ​​DTR

[Back](./ReadMe.md)

Backups and disaster recovery
=============================

Estimated reading time: 6 minutes

> The documentation herein is for UCP version 2.2.22.
>
> Use the drop-down below to access documentation for the current version or for a different past version.
>
> 2.2.22

When you decide to start using Docker Universal Control Plane on a production setting, you should [configure it for high availability](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/configure/set-up-high-availability/).

The next step is creating a backup policy and disaster recovery plan.

Data managed by UCP[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#data-managed-by-ucp)
---------------------------------------------------------------------------------------------------------------------------------

UCP maintains data about:

| Data | Description |
| --- | --- |
| Configurations | The UCP cluster configurations, as shown by `docker config ls`, including Docker Enterprise license and swarm and client CAs |
| Access control | Permissions for teams to swarm resources, including collections, grants, and roles |
| Certificates and keys | The certificates, public keys, and private keys that are used for authentication and mutual TLS communication |
| Metrics data | Monitoring data gathered by UCP |
| Organizations | Your users, teams, and orgs |
| Volumes | All [UCP named volumes](https://docs.docker.com/datacenter/ucp/2.2/guides/architecture/#volumes-used-by-ucp), which include all UCP component certs and data |

This data is persisted on the host running UCP, using named volumes. [Learn more about UCP named volumes](https://docs.docker.com/datacenter/ucp/2.2/guides/architecture/).

Backup steps[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#backup-steps)
-------------------------------------------------------------------------------------------------------------------

Back up your Docker Enterprise components in the following order:

1.  [Back up your swarm](https://docs.docker.com/engine/swarm/admin_guide/#back-up-the-swarm)
2.  Back up UCP
3.  [Back up DTR](https://docs.docker.com/datacenter/dtr/2.3/guides/admin/backups-and-disaster-recovery/)

Backup policy[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#backup-policy)
---------------------------------------------------------------------------------------------------------------------

As part of your backup policy you should regularly create backups of UCP. DTR is backed up independently. [Learn about DTR backups and recovery](https://docs.docker.com/datacenter/dtr/2.3/guides/admin/backups-and-disaster-recovery/).

To create a UCP backup, run the `docker/ucp:2.2.22 backup` command on a single UCP manager. This command creates a tar archive with the contents of all the [volumes used by UCP](https://docs.docker.com/datacenter/ucp/2.2/guides/architecture/) to persist data and streams it to stdout. The backup doesn't include the swarm-mode state, like service definitions and overlay network definitions.

You only need to run the backup command on a single UCP manager node. Since UCP stores the same data on all manager nodes, you only need to take periodic backups of a single manager node.

To create a consistent backup, the backup command temporarily stops the UCP containers running on the node where the backup is being performed. User resources, such as services, containers, and stacks are not affected by this operation and will continue operating as expected. Any long-lasting `exec`, `logs`, `events`, or `attach` operations on the affected manager node will be disconnected.

Additionally, if UCP is not configured for high availability, you will be temporarily unable to:

-   Log in to the UCP Web UI
-   Perform CLI operations using existing client bundles

To minimize the impact of the backup policy on your business, you should:

-   Configure UCP for [high availability](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/configure/set-up-high-availability/). This allows load-balancing user requests across multiple UCP manager nodes.
-   Schedule the backup to take place outside business hours.

Backup command[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#backup-command)
-----------------------------------------------------------------------------------------------------------------------

The example below shows how to create a backup of a UCP manager node and verify its contents:

```
# Create a backup, encrypt it, and store it on /tmp/backup.tar
docker container run\
  --log-driver none --rm\
  --interactive\
  --name ucp\
  -v /var/run/docker.sock:/var/run/docker.sock\
  docker/ucp:2.2.22 backup\
  --id <ucp-instance-id>\
  --passphrase "secret" > /tmp/backup.tar

# Decrypt the backup and list its contents
$ gpg --decrypt /tmp/backup.tar | tar --list

```

### Security-Enhanced Linux (SELinux)[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#security-enhanced-linux-selinux)

For Docker Enterprise 17.06 or higher, if the Docker engine has SELinux enabled, which is typical for RHEL hosts, you need to include `--security-opt label=disable` in the `docker` command:

```
$ docker container run --security-opt label=disable --log-driver none --rm -i --name ucp\
  -v /var/run/docker.sock:/var/run/docker.sock\
  docker/ucp:2.2.22 backup --interactive > /tmp/backup.tar

```

To find out whether SELinux is enabled in the engine, view the host's `/etc/docker/daemon.json` file and search for the string `"selinux-enabled":"true"`.

Restore UCP[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#restore-ucp)
-----------------------------------------------------------------------------------------------------------------

To restore an existing UCP installation from a backup, you need to uninstall UCP from the swarm by using the `uninstall-ucp` command. [Learn to uninstall UCP](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/install/uninstall/).

When restoring, make sure you use the same version of the `docker/ucp` image that you've used to create the backup. The example below shows how to restore UCP from an existing backup file, presumed to be located at `/tmp/backup.tar`:

```
$ docker container run --rm -i --name ucp\
  -v /var/run/docker.sock:/var/run/docker.sock\
  docker/ucp:2.2.22 restore < /tmp/backup.tar

```

If the backup file is encrypted with a passphrase, you will need to provide the passphrase to the restore operation:

```
$ docker container run --rm -i --name ucp\
  -v /var/run/docker.sock:/var/run/docker.sock\
  docker/ucp:2.2.22 restore --passphrase "secret" < /tmp/backup.tar

```

The restore command may also be invoked in interactive mode, in which case the backup file should be mounted to the container rather than streamed through stdin:

```
$ docker container run --rm -i --name ucp\
  -v /var/run/docker.sock:/var/run/docker.sock\
  -v /tmp/backup.tar:/config/backup.tar\
  docker/ucp:2.2.22 restore -i

```

### UCP and Swarm[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#ucp-and-swarm)

UCP restore recovers the following assets from the backup file:

-   Users, teams, and permissions.
-   All UCP configuration options available under `Admin Settings`, like the Docker Enterpirise subscription license, scheduling options, content trust, and authentication backends.

UCP restore does not include swarm assets such as cluster membership, services, networks, secrets, etc. [Learn to backup a swarm](https://docs.docker.com/engine/swarm/admin_guide/#back-up-the-swarm).

There are two ways to restore UCP:

-   On a manager node of an existing swarm which does not have UCP installed. In this case, UCP restore will use the existing swarm.
-   On a docker engine that isn't participating in a swarm. In this case, a new swarm is created and UCP is restored on top.

Disaster recovery[](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/backups-and-disaster-recovery/#disaster-recovery)
-----------------------------------------------------------------------------------------------------------------------------

In the event where half or more manager nodes are lost and cannot be recovered to a healthy state, the system is considered to have lost quorum and can only be restored through the following disaster recovery procedure. If your cluster has lost quorum, you can still take a backup of one of the remaining nodes, but we recommend making backups regularly.

This procedure is not guaranteed to succeed with no loss of running services or configuration data. To properly protect against manager failures, the system should be configured for [high availability](https://docs.docker.com/datacenter/ucp/2.2/guides/admin/configure/set-up-high-availability/).

1.  On one of the remaining manager nodes, perform `docker swarm init --force-new-cluster`. You may also need to specify an `--advertise-addr` parameter which is equivalent to the `--host-address` parameter of the `docker/ucp install` operation. This will instantiate a new single-manager swarm by recovering as much state as possible from the existing manager. This is a disruptive operation and existing tasks may be either terminated or suspended.
2.  Obtain a backup of one of the remaining manager nodes if one is not already available.
3.  If UCP is still installed on the swarm, uninstall UCP using the `uninstall-ucp` command.
4.  Perform a restore operation on the recovered swarm manager node.
5.  Log in to UCP and browse to the nodes page, or use the CLI `docker node ls` command.
6.  If any nodes are listed as `down`, you need to manually [remove these nodes](https://docs.docker.com/datacenter/ucp/2.2/guides/configure/scale-your-cluster/) from the swarm and then re-join them using a `docker swarm join` operation with the swarm's new join-token.