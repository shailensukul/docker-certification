# Installation and Configuration > Demonstrate​​ the​ ​ability​​ to​ ​upgrade ​​the ​​Docker ​​engine 

[Back](./ReadMe.md)

#### UPGRADE DOCKER ENGINE - COMMUNITY

To upgrade Docker Engine - Community, first run `sudo apt-get update`, then follow the [installation instructions](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce), choosing the new version you want to install.

### Install from a package[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#upgrade-docker-engine---community#install-from-a-package)

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

### Install using the convenience script[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#upgrade-docker-engine---community#install-using-the-convenience-script)

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

Uninstall Docker Engine - Community[](https://docs.docker.com/install/linux/docker-ce/ubuntu/#upgrade-docker-engine---community#uninstall-docker-engine---community)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

1.  Uninstall the Docker Engine - Community package:

    ```
    $ sudo apt-get purge docker-ce

    ```

2.  Images, containers, volumes, or customized configuration files on your host are not automatically removed. To delete all images, containers, and volumes:

    ```
    $ sudo rm -rf /var/lib/docker

    ```

You must delete any edited configuration files manually.