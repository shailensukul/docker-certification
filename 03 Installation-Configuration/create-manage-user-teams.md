# Installation-Configuration > Create​​ and ​​manage ​​user​ ​and ​​teams

[Back](./ReadMe.md)

Create and manage teams in DTR
==============================

Estimated reading time: 1 minute

> The documentation herein is for DTR version 2.4.14.

You can extend a user's default permissions by granting them individual permissions in other image repositories, by adding the user to a team. A team defines the permissions a set of users have for a set of repositories.

To create a new team, go to the DTR web UI, and navigate to the Organizations page. Then click the organization where you want to create the team. In this example, we create the 'billing' team under the 'whale' organization.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/create-and-manage-teams-1.png)

Click '+' to create a new team, and give it a name.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/create-and-manage-teams-2.png)

Add users to a team[](https://docs.docker.com/datacenter/dtr/2.4/guides/admin/manage-users/create-and-manage-teams/#add-users-to-a-team)
----------------------------------------------------------------------------------------------------------------------------------------

Once you have created a team, click the team name, to manage its settings. The first thing we need to do is add users to the team. Click the Add user button and add users to the team.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/create-and-manage-teams-3.png)

Manage team permissions[](https://docs.docker.com/datacenter/dtr/2.4/guides/admin/manage-users/create-and-manage-teams/#manage-team-permissions)
------------------------------------------------------------------------------------------------------------------------------------------------

The next step is to define the permissions this team has for a set of repositories. Navigate to the Repositories tab, and click the Add repository button.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/create-and-manage-teams-4.png)

Choose the repositories this team has access to, and what permission levels the team members have.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/create-and-manage-teams-5.png)

There are three permission levels available:

| Permission level | Description |
| --- | --- |
| Read only | View repository and pull images. |
| Read & Write | View repository, pull and push images. |
| Admin | Manage repository and change its settings, pull and push images. |

Create and manage users in DTR
==============================

Estimated reading time: 1 minute

> The documentation herein is for DTR version 2.4.14.
>
> Use the drop-down below to access documentation for the current version or for a different past version.
>
> 2.4.14

When using the built-in authentication, you can create users to grant them fine-grained permissions. Users are shared across UCP and DTR. When you create a new user in Docker Universal Control Plane, that user becomes available in DTR and vice versa.

To create a new user, go to the DTR web UI, and navigate to the Users page.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/create-manage-users-1.png)

Click the New user button, and fill-in the user information.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/create-manage-users-2.png)

Check the Trusted Registry admin option, if you want to grant permissions for the user to be a UCP and DTR administrator.

Permission levels in DTR
========================

Estimated reading time: 2 minutes

> The documentation herein is for DTR version 2.4.14.
>
> Use the drop-down below to access documentation for the current version or for a different past version.
>
> 2.4.14

Docker Trusted Registry allows you to define fine-grain permissions over image repositories.

Administrator users[](https://docs.docker.com/datacenter/dtr/2.4/guides/admin/manage-users/permission-levels/#administrator-users)
----------------------------------------------------------------------------------------------------------------------------------

Users are shared across UCP and DTR. When you create a new user in Docker Universal Control Plane, that user becomes available in DTR and vice versa. When you create an administrator user in DTR, the user has permissions to:

-   Manage users across UCP and DTR,
-   Manage DTR repositories and settings,
-   Manage UCP resources and settings.

Team permission levels[](https://docs.docker.com/datacenter/dtr/2.4/guides/admin/manage-users/permission-levels/#team-permission-levels)
----------------------------------------------------------------------------------------------------------------------------------------

Teams allow you to define the permissions a set of user has for a set of repositories. Three permission levels are available:

| Repository operation | read | read-write | admin |
| --- | --- | --- | --- |
| View/ browse | x | x | x |
| Pull | x | x | x |
| Push |   | x | x |
| Start a scan |   | x | x |
| Delete tags |   | x | x |
| Edit description |   |   | x |
| Set public or private |   |   | x |
| Manage user access |   |   | x |
| Delete repository |   |   | x |

Team permissions are additive. When a user is a member of multiple teams, they have the highest permission level defined by those teams.

Overall permissions[](https://docs.docker.com/datacenter/dtr/2.4/guides/admin/manage-users/permission-levels/#overall-permissions)
----------------------------------------------------------------------------------------------------------------------------------

Here's an overview of the permission levels available in DTR:

-   Anonymous users: Can search and pull public repositories.
-   Users: Can search and pull public repos, and create and manage their own repositories.
-   Team member: Everything a user can do, plus the permissions granted by the teams the user is member of.
-   Team admin: Everything a team member can do, and can also add members to the team.
-   Organization admin: Everything a team admin can do, can create new teams, and add members to the organization.
-   Admin: Can manage anything across UCP and DTR.

Authentication and authorization in DTR

=======================================

Estimated reading time: 1 minute

> The documentation herein is for DTR version 2.4.14.

>

> Use the drop-down below to access documentation for the current version or for a different past version.

>

> 2.4.14

With DTR you get to control which users have access to your image repositories.

By default, anonymous users can only pull images from public repositories. They can't create new repositories or push to existing ones. You can then grant permissions to enforce fine-grained access control to image repositories. For that:

-   Start by creating a user.

    Users are shared across UCP and DTR. When you create a new user in Docker Universal Control Plane, that user becomes available in DTR and vice versa. Registered users can create and manage their own repositories.

    You can also integrate with an LDAP service to manage users from a single place.

-   Extend the permissions by adding the user to a team.

    To extend a user's permission and manage their permissions over repositories, you add the user to a team. A team defines the permissions users have for a set of repositories.

Organizations and teams[](https://docs.docker.com/datacenter/dtr/2.4/guides/admin/manage-users/#organizations-and-teams)

------------------------------------------------------------------------------------------------------------------------

When a user creates a repository, only that user can make changes to the repository settings, and push new images to it.

Organizations take permission management one step further, since they allow multiple users to own and manage a common set of repositories. This is useful when implementing team workflows. With organizations you can delegate the management of a set of repositories and user permissions to the organization administrators.

An organization owns a set of repositories, and defines a set of teams. With teams you can define fine-grain permissions that a team of user has for a set of repositories.

![](https://docs.docker.com/datacenter/dtr/2.4/guides/images/authentication-authorization-1.svg)

In this example, the 'Whale' organization has three repositories and two teams:

-   Members of the blog team can only see and pull images from the whale/java repository,

-   Members of the billing team can manage the whale/golang repository, and push and pull images from the whale/java repository.