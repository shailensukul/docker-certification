# Security > Demonstrate ​​creation ​​of ​​UCP ​​client ​​bundles

[Back](./ReadMe.md)

Get Familiar with Docker Enterprise Edition Client Bundles
==========================================================

[BRIAN KAUFMAN](https://www.docker.com/blog/author/brian-kaufman/ "Posts by Brian Kaufman")\
Sep 20 2017

Docker Enterprise Edition (EE) is the only Containers as a Service (CaaS) Platform for IT that manages and secures diverse applications across disparate infrastructure, both on-premises and in the cloud.

There's a little mentioned big feature in Docker Enterprise Edition (EE) that seems to always bring smiles to the room once it's displayed. Before I tell you about it, let me first describe the use case. You're a sysadmin managing a Docker cluster and you have the following requirements:

-   Different individuals in your LDAP/AD need various levels of access to the containers/services in your cluster
-   Some users need to be able to go inside the running containers.
-   Some users just need to be able to see the logs
-   You do NOT want to give SSH access to each host in your cluster.

Now, how do you achieve this? The answer, or feature rather, is a client bundle. When you do a docker version command you will see two entries. The client portion of the engine is able to connect to a local server AND a remote once a client bundle is invoked.

![Docker Enterprise Edition Client Bundles](https://i0.wp.com/www.docker.com/blog/wp-content/uploads/83fffc1c-58ea-4eee-893f-eab41742f748.jpg?resize=402%2C339&ssl=1)

What is a client bundle?
------------------------

A client bundle is a group of certificates downloadable directly from the [Docker Universal Control Plane (](https://docs.docker.com/datacenter/ucp/2.2/guides/)[UCP](https://docs.docker.com/datacenter/ucp/2.2/guides/)[)](https://docs.docker.com/datacenter/ucp/2.2/guides/) user interface within the admin section for "My Profile". This allows you to authorize a remote Docker engine to a specific user account managed in Docker EE, absorbing all associated RBAC controls in the process. You can now execute docker swarm commands from your remote machine that take effect on the remote cluster.

Example:

I have a user named 'bkauf' in my UCP. I download and extract a client bundle for this user.

![Docker Enterprise Edition Client Bundles](https://i0.wp.com/www.docker.com/blog/wp-content/uploads/8bf94878-7aff-4b41-9a53-4bdb2a6a62c0-3.jpg?resize=1448%2C603&ssl=1)

![Docker Enterprise Edition Client Bundles](https://i2.wp.com/www.docker.com/blog/wp-content/uploads/ecc078b8-ecac-428e-9ae8-3615ca5e9ff1-3.jpg?resize=359%2C336&ssl=1)

I open a terminal session with my docker for mac and issue a docker version command. You will see the server version matches the client. I can do a docker ps and verify nothing is running.

![Docker Enterprise Edition Client Bundles](https://i2.wp.com/www.docker.com/blog/wp-content/uploads/710369c2-3289-4fe6-a444-ad63576563a3-9.jpg?resize=688%2C696&ssl=1)

Now, I navigate to the extracted bundle directory and run the env.sh script (env.ps1 for windows)

![Docker Enterprise Edition Client Bundles](https://i2.wp.com/www.docker.com/blog/wp-content/uploads/0a46d08f-8e63-4831-8b8f-5f5b33f954e9-3.jpg?resize=695%2C677&ssl=1)

Notice the server now lists my version as ucp/2.2.2. This is the version of my UCP manager; I'm remotely connected from my laptop to my remote cluster assuming the bkauf user's access levels. I can now do various things such as create a service, view its tasks(containers) and even log into this REMOTE container from my laptop all through the API, no SSH access needed. I need not worry about what host the container is on! This is made possible by the role/permission set up for the use with the granular Role Based Access Control available with Docker EE.

![Docker Enterprise Edition Client Bundles](https://i2.wp.com/www.docker.com/blog/wp-content/uploads/9563b27f-c472-448a-83c6-fb2ad79d58d9-3.jpg?resize=1001%2C210&ssl=1)

![Docker Enterprise Edition Client Bundles](https://i2.wp.com/www.docker.com/blog/wp-content/uploads/e768801c-85a1-4050-bc41-7fafc5a8aadf-3.jpg?resize=1112%2C632&ssl=1)

What about a Windows container on a Windows node in a UCP cluster you ask? Linux OR Windows nodes, remote access through your client bundle all works the same!

![Docker Enterprise Edition Client Bundles](https://i0.wp.com/www.docker.com/blog/wp-content/uploads/124c1cbe-6960-4ff2-9bb9-34ad68c758b6-3.jpg?resize=1572%2C550&ssl=1)

 Docker Enterprise Edition (EE) is the only Containers as a Service (CaaS) Platform for IT that manages and secures diverse applications across disparate infrastructure, both on-premises and in the cloud. Docker EE embraces both traditional applications and microservices, built on Linux and Windows, and intended for x86 servers, mainframes, and public clouds. Docker EE unites all of these applications into single platform, complete with customizable and flexible access control, support for a broad range of applications and infrastructure, and a highly automated software supply chain.