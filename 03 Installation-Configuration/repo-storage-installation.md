# Installation and Configuration > Complete​​ setup ​​of ​​repo,  ​​select ​​a ​​storage​​ driver, ​​and ​​complete​​ installation​​ of ​​Docker engine ​​on ​​multiple ​​platforms

[Back](./ReadMe.md)

Docker Engine overview
======================

Estimated reading time: 5 minutes

Docker Engine is an open source containerization technology for building and containerizing your applications. Docker Engine acts as a client-server application with:

-   A server with a long-running daemon process [`dockerd`](https://docs.docker.com/engine/reference/commandline/dockerd/).
-   APIs which specify interfaces that programs can use to talk to and instruct the Docker daemon.
-   A command line interface (CLI) client [`docker`](https://docs.docker.com/engine/reference/commandline/cli/).

The CLI uses Docker APIs to control or interact with the Docker daemon through scripting or direct CLI commands. Many other Docker applications use the underlying API and CLI. The daemon creates and manage Docker objects, such as images, containers, networks, and volumes.

Docker Engine has three types of update channels, stable, test, and nightly:

-   Stable gives you latest releases for general availability.
-   Test gives pre-releases that are ready for testing before general availability.
-   Nightly gives you latest builds of work in progress for the next major release.

For more information, see [Release channels](https://docs.docker.com/install/#release-channels).

Supported platforms[](https://docs.docker.com/install/#supported-platforms)
---------------------------------------------------------------------------

Docker Engine is available on a variety of Linux platforms, [Mac](https://docs.docker.com/docker-for-mac/install/) and [Windows](https://docs.docker.com/docker-for-windows/install/) through Docker Desktop, Windows Server, and as a static binary installation. Find your preferred operating system below.

#### DESKTOP

| Platform | x86_64 |
| --- | --- |
| [Docker Desktop for Mac (macOS)](https://docs.docker.com/docker-for-mac/install/) | ![yes](https://docs.docker.com/install/images/green-check.svg) |
| [Docker Desktop for Windows (Microsoft Windows 10)](https://docs.docker.com/docker-for-windows/install/) | ![yes](https://docs.docker.com/install/images/green-check.svg) |

#### SERVER

| Platform | x86_64 / amd64 | ARM | ARM64 / AARCH64 | IBM Power (ppc64le) | IBM Z (s390x) |
| --- | --- | --- | --- | --- | --- |
| [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/centos/) |   | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/centos/) |   |   |
| [Debian](https://docs.docker.com/install/linux/docker-ce/debian/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/debian/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/debian/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/debian/) |   |   |
| [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/fedora/) |   | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/fedora/) |   |   |
| [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/ubuntu/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/ubuntu/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/ubuntu/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/ubuntu/) | [![yes](https://docs.docker.com/install/images/green-check.svg)](https://docs.docker.com/install/linux/docker-ce/ubuntu/) |

Release channels[](https://docs.docker.com/install/#release-channels)
---------------------------------------------------------------------

### Stable[](https://docs.docker.com/install/#stable)

Year-month releases are made from a release branch diverged from the master branch. The branch is created with format `<year>.<month>`, for example `18.09`. The year-month name indicates the earliest possible calendar month to expect the release to be generally available. All further patch releases are performed from that branch. For example, once `v18.09.0` is released, all subsequent patch releases are built from the `18.09` branch.

### Test[](https://docs.docker.com/install/#test)

In preparation for a new year-month release, a branch is created from the master branch with format `YY.mm` when the milestones desired by Docker for the release have achieved feature-complete. Pre-releases such as betas and release candidates are conducted from their respective release branches. Patch releases and the corresponding pre-releases are performed from within the corresponding release branch.

> Note: While pre-releases are done to assist in the stabilization process, no guarantees are provided.

Binaries built for pre-releases are available in the test channel for the targeted year-month release using the naming format `test-YY.mm`, for example `test-18.09`.

### Nightly[](https://docs.docker.com/install/#nightly)

Nightly builds give you the latest builds of work in progress for the next major release. They are created once per day from the master branch with the version format:

```
0.0.0-YYYYmmddHHMMSS-abcdefabcdef

```

where the time is the commit time in UTC and the final suffix is the prefix of the commit hash, for example `0.0.0-20180720214833-f61e0f7`.

These builds allow for testing from the latest code on the master branch.

> Note: No qualifications or guarantees are made for the nightly builds.

The release channel for these builds is called `nightly`.

Support[](https://docs.docker.com/install/#support)
---------------------------------------------------

Docker Engine releases of a year-month branch are supported with patches as needed for 7 months after the first year-month general availability release.

This means bug reports and backports to release branches are assessed until the end-of-life date.

After the year-month branch has reached end-of-life, the branch may be deleted from the repository.

### Backporting[](https://docs.docker.com/install/#backporting)

Backports to the Docker products are prioritized by the Docker company. A Docker employee or repository maintainer will endeavour to ensure sensible bugfixes make it into *active* releases.

If there are important fixes that ought to be considered for backport to active release branches, be sure to highlight this in the PR description or by adding a comment to the PR.

### Upgrade path[](https://docs.docker.com/install/#upgrade-path)

Patch releases are always backward compatible with its year-month version.

### Licensing[](https://docs.docker.com/install/#licensing)

Docker is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/moby/moby/blob/master/LICENSE) for the full license text.

Reporting security issues[](https://docs.docker.com/install/#reporting-security-issues)
---------------------------------------------------------------------------------------

The Docker maintainers take security seriously. If you discover a security issue, please bring it to their attention right away!

Please DO NOT file a public issue; instead send your report privately to security@docker.com.

Security reports are greatly appreciated, and Docker will publicly thank you for it.

Get started[](https://docs.docker.com/install/#get-started)
-----------------------------------------------------------

After setting up Docker, you can learn the basics with [Getting started with Docker](https://docs.docker.com/get-started/).