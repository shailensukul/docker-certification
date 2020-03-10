# Installation-Configuration > Consistently​​ repeat​​ steps ​​to ​​deploy ​​Docker ​​​​engine, ​​UCP, ​​and ​​DTR and Docker ​​on ​​AWS ​​and ​​on premises ​​in ​​an​ ​HA ​​config


[Back](./ReadMe.md)

Get Docker Engine - Community for Ubuntu
========================================

Estimated reading time: 12 minutes

To get started with Docker Engine - Community on Ubuntu, make sure you [meet the prerequisites](https://docs.docker.com/install/linux/docker-ce/ubuntu/#prerequisites), then [install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-engine---community-1).

Prerequisites[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#prerequisites)
--------------------------------------------------------------------------------------

### Docker EE customers[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#docker-ee-customers)

To install Docker Enterprise Edition (Docker EE), go to [Get Docker EE for Ubuntu](https://docs.docker.com/install/linux/docker-ee/ubuntu/) instead of this topic.

To learn more about Docker EE, see [Docker Enterprise Edition](https://www.docker.com/enterprise-edition/).

### OS requirements[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#os-requirements)

To install Docker Engine - Community, you need the 64-bit version of one of these Ubuntu versions:

-   Eoan 19.10
-   Bionic 18.04 (LTS)
-   Xenial 16.04 (LTS)

Docker Engine - Community is supported on `x86_64` (or `amd64`), `armhf`, `arm64`, `s390x` (IBM Z), and `ppc64le` (IBM Power) architectures.

### Uninstall old versions[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#uninstall-old-versions)

Older versions of Docker were called `docker`, `docker.io`, or `docker-engine`. If these are installed, uninstall them:

```
$ sudo apt-get remove docker docker-engine docker.io containerd runc

```

It's OK if `apt-get` reports that none of these packages are installed.

The contents of `/var/lib/docker/`, including images, containers, volumes, and networks, are preserved. The Docker Engine - Community package is now called `docker-ce`.

### Supported storage drivers[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#supported-storage-drivers)

Docker Engine - Community on Ubuntu supports `overlay2`, `aufs` and `btrfs` storage drivers.

> Note: In Docker Engine - Enterprise, `btrfs` is only supported on SLES. See the documentation on [btrfs](https://docs.docker.com/engine/userguide/storagedriver/btrfs-driver/) for more details.

For new installations on version 4 and higher of the Linux kernel, `overlay2` is supported and preferred over `aufs`. Docker Engine - Community uses the `overlay2` storage driver by default. If you need to use `aufs` instead, you need to configure it manually. See [aufs](https://docs.docker.com/engine/userguide/storagedriver/aufs-driver/)

Install Docker Engine - Community[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-engine---community)
------------------------------------------------------------------------------------------------------------------------------

You can install Docker Engine - Community in different ways, depending on your needs:

-   Most users [set up Docker's repositories](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository) and install from them, for ease of installation and upgrade tasks. This is the recommended approach.

-   Some users download the DEB package and [install it manually](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-from-a-package) and manage upgrades completely manually. This is useful in situations such as installing Docker on air-gapped systems with no access to the internet.

-   In testing and development environments, some users choose to use automated [convenience scripts](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-convenience-script) to install Docker.

### Install using the repository[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository)

Before you install Docker Engine - Community for the first time on a new host machine, you need to set up the Docker repository. Afterward, you can install and update Docker from the repository.

#### SET UP THE REPOSITORY

1.  Update the `apt` package index:

    ```
    $ sudo apt-get update

    ```

2.  Install packages to allow `apt` to use a repository over HTTPS:

    ```
    $ sudo apt-get install\
        apt-transport-https\
        ca-certificates\
        curl\
        gnupg-agent\
        software-properties-common

    ```

3.  Add Docker's official GPG key:

    ```
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    ```

    Verify that you now have the key with the fingerprint `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`, by searching for the last 8 characters of the fingerprint.

    ```
    $ sudo apt-key fingerprint 0EBFCD88

    pub   rsa4096 2017-02-22 [SCEA]
          9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
    uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
    sub   rsa4096 2017-02-22 [S]

    ```

4.  Use the following command to set up the stable repository. To add the nightly or test repository, add the word `nightly` or `test` (or both) after the word `stable` in the commands below. [Learn about nightly and test channels](https://docs.docker.com/install/).

    > Note: The `lsb_release -cs` sub-command below returns the name of your Ubuntu distribution, such as `xenial`. Sometimes, in a distribution like Linux Mint, you might need to change `$(lsb_release -cs)` to your parent Ubuntu distribution. For example, if you are using `Linux Mint Tessa`, you could use `bionic`. Docker does not offer any guarantees on untested and unsupported Ubuntu distributions.

    -   x86_64 / amd64
    -   armhf
    -   arm64
    -   ppc64le (IBM Power)
    -   s390x (IBM Z)

    ```
    $ sudo add-apt-repository\
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu\
       $(lsb_release -cs)\
       stable"

    ```

#### INSTALL DOCKER ENGINE - COMMUNITY

1.  Update the `apt` package index.

    ```
    $ sudo apt-get update

    ```

2.  Install the *latest version* of Docker Engine - Community and containerd, or go to the next step to install a specific version:

    ```
    $ sudo apt-get install docker-ce docker-ce-cli containerd.io

    ```

    > Got multiple Docker repositories?
    >
    > If you have multiple Docker repositories enabled, installing or updating without specifying a version in the `apt-get install` or `apt-get update` command always installs the highest possible version, which may not be appropriate for your stability needs.

3.  To install a *specific version* of Docker Engine - Community, list the available versions in the repo, then select and install:

    a. List the versions available in your repo:

    ```
    $ apt-cache madison docker-ce

      docker-ce | 5:18.09.1~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
      docker-ce | 5:18.09.0~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
      docker-ce | 18.06.1~ce~3-0~ubuntu       | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
      docker-ce | 18.06.0~ce~3-0~ubuntu       | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
      ...

    ```

    b. Install a specific version using the version string from the second column, for example, `5:18.09.1~3-0~ubuntu-xenial`.

    ```
    $ sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

    ```

4.  Verify that Docker Engine - Community is installed correctly by running the `hello-world` image.

    ```
    $ sudo docker run hello-world

    ```

    This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.

Docker Engine - Community is installed and running. The `docker` group is created but no users are added to it. You need to use `sudo` to run Docker commands. Continue to [Linux postinstall](https://docs.docker.com/install/linux/linux-postinstall/) to allow non-privileged users to run Docker commands and for other optional configuration steps.

#### UPGRADE DOCKER ENGINE - COMMUNITY

To upgrade Docker Engine - Community, first run `sudo apt-get update`, then follow the [installation instructions](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce), choosing the new version you want to install.

### Install from a package[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-from-a-package)

If you cannot use Docker's repository to install Docker Engine - Community, you can download the `.deb` file for your release and install it manually. You need to download a new file each time you want to upgrade Docker.

1.  Go to [`https://download.docker.com/linux/ubuntu/dists/`](https://download.docker.com/linux/ubuntu/dists/), choose your Ubuntu version, browse to `pool/stable/`, choose `amd64`, `armhf`, `arm64`, `ppc64el`, or `s390x`, and download the `.deb` file for the Docker Engine - Community version you want to install.

    > Note: To install a nightly package, change the word `stable` in the URL to `nightly`. [Learn about nightly and test channels](https://docs.docker.com/install/).

2.  Install Docker Engine - Community, changing the path below to the path where you downloaded the Docker package.

    ```
    $ sudo dpkg -i /path/to/package.deb

    ```

    The Docker daemon starts automatically.

3.  Verify that Docker Engine - Community is installed correctly by running the `hello-world` image.

    ```
    $ sudo docker run hello-world

    ```

    This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.

Docker Engine - Community is installed and running. The `docker` group is created but no users are added to it. You need to use `sudo` to run Docker commands. Continue to [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/) to allow non-privileged users to run Docker commands and for other optional configuration steps.

#### UPGRADE DOCKER ENGINE - COMMUNITY

To upgrade Docker Engine - Community, download the newer package file and repeat the [installation procedure](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-from-a-package), pointing to the new file.

### Install using the convenience script[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-convenience-script)

Docker provides convenience scripts at [get.docker.com](https://get.docker.com/) and [test.docker.com](https://test.docker.com/) for installing edge and testing versions of Docker Engine - Community into development environments quickly and non-interactively. The source code for the scripts is in the [`docker-install` repository](https://github.com/docker/docker-install). Using these scripts is not recommended for production environments, and you should understand the potential risks before you use them:

-   The scripts require `root` or `sudo` privileges to run. Therefore, you should carefully examine and audit the scripts before running them.
-   The scripts attempt to detect your Linux distribution and version and configure your package management system for you. In addition, the scripts do not allow you to customize any installation parameters. This may lead to an unsupported configuration, either from Docker's point of view or from your own organization's guidelines and standards.
-   The scripts install all dependencies and recommendations of the package manager without asking for confirmation. This may install a large number of packages, depending on the current configuration of your host machine.
-   The script does not provide options to specify which version of Docker to install, and installs the latest version that is released in the "edge" channel.
-   Do not use the convenience script if Docker has already been installed on the host machine using another mechanism.

This example uses the script at [get.docker.com](https://get.docker.com/) to install the latest release of Docker Engine - Community on Linux. To install the latest testing version, use [test.docker.com](https://test.docker.com/) instead. In each of the commands below, replace each occurrence of `get` with `test`.

> Warning:
>
> Always examine scripts downloaded from the internet before running them locally.

```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh

<output truncated>

```

If you would like to use Docker as a non-root user, you should now consider adding your user to the "docker" group with something like:

```
  sudo usermod -aG docker your-user

```

Remember to log out and back in for this to take effect!

> Warning:
>
> Adding a user to the "docker" group grants them the ability to run containers which can be used to obtain root privileges on the Docker host. Refer to [Docker Daemon Attack Surface](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface) for more information.

Docker Engine - Community is installed. It starts automatically on `DEB`-based distributions. On `RPM`-based distributions, you need to start it manually using the appropriate `systemctl` or `service` command. As the message indicates, non-root users can't run Docker commands by default.

> Note:
>
> To install Docker without root privileges, see [Run the Docker daemon as a non-root user (Rootless mode)](https://docs.docker.com/engine/security/rootless/).
>
> Rootless mode is currently available as an experimental feature.

#### UPGRADE DOCKER AFTER USING THE CONVENIENCE SCRIPT

If you installed Docker using the convenience script, you should upgrade Docker using your package manager directly. There is no advantage to re-running the convenience script, and it can cause issues if it attempts to re-add repositories which have already been added to the host machine.

Uninstall Docker Engine - Community[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#uninstall-docker-engine---community)
----------------------------------------------------------------------------------------------------------------------------------

1.  Uninstall the Docker Engine - Community package:

    ```
    $ sudo apt-get purge docker-ce

    ```

2.  Images, containers, volumes, or customized configuration files on your host are not automatically removed. To delete all images, containers, and volumes:

    ```
    $ sudo rm -rf /var/lib/docker

    ```

You must delete any edited configuration files manually.

Post-installation steps for Linux
=================================

Estimated reading time: 16 minutes

This section contains optional procedures for configuring Linux hosts to work better with Docker.

Manage Docker as a non-root user[](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user)
-----------------------------------------------------------------------------------------------------------------------------

The Docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user `root` and other users can only access it using `sudo`. The Docker daemon always runs as the `root` user.

If you don't want to preface the `docker` command with `sudo`, create a Unix group called `docker` and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the `docker` group.

> Warning
>
> The `docker` group grants privileges equivalent to the `root` user. For details on how this impacts security in your system, see [*Docker Daemon Attack Surface*](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface).

> Note:
>
> To run Docker without root privileges, see [Run the Docker daemon as a non-root user (Rootless mode)](https://docs.docker.com/engine/security/rootless/).
>
> Rootless mode is currently available as an experimental feature.

To create the `docker` group and add your user:

1.  Create the `docker` group.

    ```
    $ sudo groupadd docker

    ```

2.  Add your user to the `docker` group.

    ```
    $ sudo usermod -aG docker $USER

    ```

3.  Log out and log back in so that your group membership is re-evaluated.

    If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

    On a desktop Linux environment such as X Windows, log out of your session completely and then log back in.

    On Linux, you can also run the following command to activate the changes to groups:

    ```
    $ newgrp docker

    ```

4.  Verify that you can run `docker` commands without `sudo`.

    ```
    $ docker run hello-world

    ```

    This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.

    If you initially ran Docker CLI commands using `sudo` before adding your user to the `docker` group, you may see the following error, which indicates that your `~/.docker/` directory was created with incorrect permissions due to the `sudo` commands.

    ```
    WARNING: Error loading config file: /home/user/.docker/config.json -
    stat /home/user/.docker/config.json: permission denied

    ```

    To fix this problem, either remove the `~/.docker/` directory (it is recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands:

    ```
    $ sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    $ sudo chmod g+rwx "$HOME/.docker" -R

    ```

Configure Docker to start on boot[](https://docs.docker.com/install/linux/linux-postinstall/#configure-docker-to-start-on-boot)
-------------------------------------------------------------------------------------------------------------------------------

Most current Linux distributions (RHEL, CentOS, Fedora, Ubuntu 16.04 and higher) use [`systemd`](https://docs.docker.com/install/linux/linux-postinstall/#systemd) to manage which services start when the system boots. Ubuntu 14.10 and below use [`upstart`](https://docs.docker.com/install/linux/linux-postinstall/#upstart).

### `systemd`[](https://docs.docker.com/install/linux/linux-postinstall/#systemd)

```
$ sudo systemctl enable docker

```

To disable this behavior, use `disable` instead.

```
$ sudo systemctl disable docker

```

If you need to add an HTTP Proxy, set a different directory or partition for the Docker runtime files, or make other customizations, see [customize your systemd Docker daemon options](https://docs.docker.com/engine/admin/systemd/).

### `upstart`[](https://docs.docker.com/install/linux/linux-postinstall/#upstart)

Docker is automatically configured to start on boot using `upstart`. To disable this behavior, use the following command:

```
$ echo manual | sudo tee /etc/init/docker.override

```

### `chkconfig`[](https://docs.docker.com/install/linux/linux-postinstall/#chkconfig)

```
$ sudo chkconfig docker on

```

Use a different storage engine[](https://docs.docker.com/install/linux/linux-postinstall/#use-a-different-storage-engine)
-------------------------------------------------------------------------------------------------------------------------

For information about the different storage engines, see [Storage drivers](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/). The default storage engine and the list of supported storage engines depend on your host's Linux distribution and available kernel drivers.

Configure default logging driver[](https://docs.docker.com/install/linux/linux-postinstall/#configure-default-logging-driver)
-----------------------------------------------------------------------------------------------------------------------------

Docker provides the [capability](https://docs.docker.com/config/containers/logging/) to collect and view log data from all containers running on a host via a series of logging drivers. The default logging driver, `json-file`, writes log data to JSON-formatted files on the host filesystem. Over time, these log files expand in size, leading to potential exhaustion of disk resources. To alleviate such issues, either configure an alternative logging driver such as Splunk or Syslog, or [set up log rotation](https://docs.docker.com/config/containers/logging/configure/#configure-the-default-logging-driver) for the default driver. If you configure an alternative logging driver, see [Use `docker logs` to read container logs for remote logging drivers](https://docs.docker.com/config/containers/logging/dual-logging/).

Configure where the Docker daemon listens for connections[](https://docs.docker.com/install/linux/linux-postinstall/#configure-where-the-docker-daemon-listens-for-connections)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

By default, the Docker daemon listens for connections on a UNIX socket to accept requests from local clients. It is possible to allow Docker to accept requests from remote hosts by configuring it to listen on an IP address and port as well as the UNIX socket. For more detailed information on this configuration option take a look at "Bind Docker to another host/port or a unix socket" section of the [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/dockerd/) article.

> Docker EE customers
>
> Docker EE customers can get remote CLI access to UCP with the UCP client bundle. A UCP Client Bundle is generated by UCP and secured by mutual TLS. See the document on [CLI access for UCP](https://docs.docker.com/ee/ucp/user-access/cli/) for more information.

> Secure your connection
>
> Before configuring Docker to accept connections from remote hosts it is critically important that you understand the security implications of opening docker to the network. If steps are not taken to secure the connection, it is possible for remote non-root users to gain root access on the host. For more information on how to use TLS certificates to secure this connection, check this article on [how to protect the Docker daemon socket](https://docs.docker.com/engine/security/https/).

Configuring Docker to accept remote connections can be done with the `docker.service` systemd unit file for Linux distributions using systemd, such as recent versions of RedHat, CentOS, Ubuntu and SLES, or with the `daemon.json` file which is recommended for Linux distributions that do not use systemd.

> systemd vs daemon.json
>
> Configuring Docker to listen for connections using both the `systemd` unit file and the `daemon.json` file causes a conflict that prevents Docker from starting.

### Configuring remote access with `systemd` unit file[](https://docs.docker.com/install/linux/linux-postinstall/#configuring-remote-access-with-systemd-unit-file)

1.  Use the command `sudo systemctl edit docker.service` to open an override file for `docker.service` in a text editor.

2.  Add or modify the following lines, substituting your own values.

    ```
    [Service]
    ExecStart=
    ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375

    ```

3.  Save the file.

4.  Reload the `systemctl` configuration.

    ```
     $ sudo systemctl daemon-reload

    ```

5.  Restart Docker.

    ```
    $ sudo systemctl restart docker.service

    ```

6.  Check to see whether the change was honored by reviewing the output of `netstat` to confirm `dockerd` is listening on the configured port.

    ```
    $ sudo netstat -lntp | grep dockerd
    tcp        0      0 127.0.0.1:2375          0.0.0.0:*               LISTEN      3758/dockerd

    ```

### Configuring remote access with `daemon.json`[](https://docs.docker.com/install/linux/linux-postinstall/#configuring-remote-access-with-daemonjson)

1.  Set the `hosts` array in the `/etc/docker/daemon.json` to connect to the UNIX socket and an IP address, as follows:

    ```
    {
    "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
    }

    ```

2.  Restart Docker.

3.  Check to see whether the change was honored by reviewing the output of `netstat` to confirm `dockerd` is listening on the configured port.

    ```
    $ sudo netstat -lntp | grep dockerd
    tcp        0      0 127.0.0.1:2375          0.0.0.0:*               LISTEN      3758/dockerd

    ```

Enable IPv6 on the Docker daemon[](https://docs.docker.com/install/linux/linux-postinstall/#enable-ipv6-on-the-docker-daemon)
-----------------------------------------------------------------------------------------------------------------------------

To enable IPv6 on the Docker daemon, see [Enable IPv6 support](https://docs.docker.com/config/daemon/ipv6/).

Troubleshooting[](https://docs.docker.com/install/linux/linux-postinstall/#troubleshooting)
-------------------------------------------------------------------------------------------

### Kernel compatibility[](https://docs.docker.com/install/linux/linux-postinstall/#kernel-compatibility)

Docker cannot run correctly if your kernel is older than version 3.10 or if it is missing some modules. To check kernel compatibility, you can download and run the [`check-config.sh`](https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh) script.

```
$ curl https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh > check-config.sh

$ bash ./check-config.sh

```

The script only works on Linux, not macOS.

### `Cannot connect to the Docker daemon`[](https://docs.docker.com/install/linux/linux-postinstall/#cannot-connect-to-the-docker-daemon)

If you see an error such as the following, your Docker client may be configured to connect to a Docker daemon on a different host, and that host may not be reachable.

```
Cannot connect to the Docker daemon. Is 'docker daemon' running on this host?

```

To see which host your client is configured to connect to, check the value of the `DOCKER_HOST` variable in your environment.

```
$ env | grep DOCKER_HOST

```

If this command returns a value, the Docker client is set to connect to a Docker daemon running on that host. If it is unset, the Docker client is set to connect to the Docker daemon running on the local host. If it is set in error, use the following command to unset it:

```
$ unset DOCKER_HOST

```

You may need to edit your environment in files such as `~/.bashrc` or `~/.profile` to prevent the `DOCKER_HOST` variable from being set erroneously.

If `DOCKER_HOST` is set as intended, verify that the Docker daemon is running on the remote host and that a firewall or network outage is not preventing you from connecting.

### IP forwarding problems[](https://docs.docker.com/install/linux/linux-postinstall/#ip-forwarding-problems)

If you manually configure your network using `systemd-network` with `systemd` version 219 or higher, Docker containers may not be able to access your network. Beginning with `systemd` version 220, the forwarding setting for a given network (`net.ipv4.conf.<interface>.forwarding`) defaults to *off*. This setting prevents IP forwarding. It also conflicts with Docker's behavior of enabling the `net.ipv4.conf.all.forwarding` setting within containers.

To work around this on RHEL, CentOS, or Fedora, edit the `<interface>.network` file in `/usr/lib/systemd/network/` on your Docker host (ex: `/usr/lib/systemd/network/80-container-host0.network`) and add the following block within the `[Network]` section.

```
[Network]
...
IPForward=kernel
# OR
IPForward=true
...

```

This configuration allows IP forwarding from the container as expected.

### `DNS resolver found in resolv.conf and containers can't use it`[](https://docs.docker.com/install/linux/linux-postinstall/#dns-resolver-found-in-resolvconf-and-containers-cant-use-it)

Linux systems which use a GUI often have a network manager running, which uses a `dnsmasq` instance running on a loopback address such as `127.0.0.1` or `127.0.1.1` to cache DNS requests, and adds this entry to `/etc/resolv.conf`. The `dnsmasq` service speeds up DNS look-ups and also provides DHCP services. This configuration does not work within a Docker container which has its own network namespace, because the Docker container resolves loopback addresses such as `127.0.0.1` to itself, and it is very unlikely to be running a DNS server on its own loopback address.

If Docker detects that no DNS server referenced in `/etc/resolv.conf` is a fully functional DNS server, the following warning occurs and Docker uses the public DNS servers provided by Google at `8.8.8.8` and `8.8.4.4` for DNS resolution.

```
WARNING: Local (127.0.0.1) DNS resolver found in resolv.conf and containers
can't use it. Using default external servers : [8.8.8.8 8.8.4.4]

```

If you see this warning, first check to see if you use `dnsmasq`:

```
$ ps aux |grep dnsmasq

```

If your container needs to resolve hosts which are internal to your network, the public nameservers are not adequate. You have two choices:

-   You can specify a DNS server for Docker to use, or
-   You can disable `dnsmasq` in NetworkManager. If you do this, NetworkManager adds your true DNS nameserver to `/etc/resolv.conf`, but you lose the possible benefits of `dnsmasq`.

You only need to use one of these methods.

### Specify DNS servers for Docker[](https://docs.docker.com/install/linux/linux-postinstall/#specify-dns-servers-for-docker)

The default location of the configuration file is `/etc/docker/daemon.json`. You can change the location of the configuration file using the `--config-file` daemon flag. The documentation below assumes the configuration file is located at `/etc/docker/daemon.json`.

1.  Create or edit the Docker daemon configuration file, which defaults to `/etc/docker/daemon.json` file, which controls the Docker daemon configuration.

    ```
    $ sudo nano /etc/docker/daemon.json

    ```

2.  Add a `dns` key with one or more IP addresses as values. If the file has existing contents, you only need to add or edit the `dns` line.

    ```
    {
    	"dns": ["8.8.8.8", "8.8.4.4"]
    }

    ```

    If your internal DNS server cannot resolve public IP addresses, include at least one DNS server which can, so that you can connect to Docker Hub and so that your containers can resolve internet domain names.

    Save and close the file.

3.  Restart the Docker daemon.

    ```
    $ sudo service docker restart

    ```

4.  Verify that Docker can resolve external IP addresses by trying to pull an image:

    ```
    $ docker pull hello-world

    ```

5.  If necessary, verify that Docker containers can resolve an internal hostname by pinging it.

    ```
    $ docker run --rm -it alpine ping -c4 <my_internal_host>

    PING google.com (192.168.1.2): 56 data bytes
    64 bytes from 192.168.1.2: seq=0 ttl=41 time=7.597 ms
    64 bytes from 192.168.1.2: seq=1 ttl=41 time=7.635 ms
    64 bytes from 192.168.1.2: seq=2 ttl=41 time=7.660 ms
    64 bytes from 192.168.1.2: seq=3 ttl=41 time=7.677 ms

    ```

#### DISABLE `DNSMASQ`

##### Ubuntu

If you prefer not to change the Docker daemon's configuration to use a specific IP address, follow these instructions to disable `dnsmasq` in NetworkManager.

1.  Edit the `/etc/NetworkManager/NetworkManager.conf` file.

2.  Comment out the `dns=dnsmasq` line by adding a `#` character to the beginning of the line.

    ```
    # dns=dnsmasq

    ```

    Save and close the file.

3.  Restart both NetworkManager and Docker. As an alternative, you can reboot your system.

    ```
    $ sudo restart network-manager
    $ sudo restart docker

    ```

##### RHEL, CentOS, or Fedora

To disable `dnsmasq` on RHEL, CentOS, or Fedora:

1.  Disable the `dnsmasq` service:

    ```
    $ sudo service dnsmasq stop

    $ sudo systemctl disable dnsmasq

    ```

2.  Configure the DNS servers manually using the [Red Hat documentation](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s1-networkscripts-interfaces.html).

### Allow access to the remote API through a firewall[](https://docs.docker.com/install/linux/linux-postinstall/#allow-access-to-the-remote-api-through-a-firewall)

If you run a firewall on the same host as you run Docker and you want to access the Docker Remote API from another host and remote access is enabled, you need to configure your firewall to allow incoming connections on the Docker port, which defaults to `2376` if TLS encrypted transport is enabled or `2375` otherwise.

Two common firewall daemons are [UFW (Uncomplicated Firewall)](https://help.ubuntu.com/community/UFW) (often used for Ubuntu systems) and [firewalld](http://www.firewalld.org/) (often used for RPM-based systems). Consult the documentation for your OS and firewall, but the following information might help you get started. These options are fairly permissive and you may want to use a different configuration that locks your system down more.

-   UFW: Set `DEFAULT_FORWARD_POLICY="ACCEPT"` in your configuration.

-   firewalld: Add rules similar to the following to your policy (one for incoming requests and one for outgoing requests). Be sure the interface names and chain names are correct.

    ```
    <direct>
      [ <rule ipv="ipv6" table="filter" chain="FORWARD_direct" priority="0"> -i zt0 -j ACCEPT </rule> ]
      [ <rule ipv="ipv6" table="filter" chain="FORWARD_direct" priority="0"> -o zt0 -j ACCEPT </rule> ]
    </direct>

    ```

### `Your kernel does not support cgroup swap limit capabilities`[](https://docs.docker.com/install/linux/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities)

On Ubuntu or Debian hosts, You may see messages similar to the following when working with an image.

```
WARNING: Your kernel does not support swap limit capabilities. Limitation discarded.

```

This warning does not occur on RPM-based systems, which enable these capabilities by default.

If you don't need these capabilities, you can ignore the warning. You can enable these capabilities on Ubuntu or Debian by following these instructions. Memory and swap accounting incur an overhead of about 1% of the total available memory and a 10% overall performance degradation, even if Docker is not running.

1.  Log into the Ubuntu or Debian host as a user with `sudo` privileges.

2.  Edit the `/etc/default/grub` file. Add or edit the `GRUB_CMDLINE_LINUX` line to add the following two key-value pairs:

    ```
    GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"

    ```

    Save and close the file.

3.  Update GRUB.

    ```
    $ sudo update-grub

    ```

    If your GRUB configuration file has incorrect syntax, an error occurs. In this case, repeat steps 2 and 3.

    The changes take effect when the system is rebooted.