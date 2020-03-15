# Storage and Volumes > Identify​​ the​​ steps ​​you ​​would ​​take ​​to ​​clean​​up ​​unused ​​images​​ on ​​a ​​filesystem,​​ also on DTR > From DTR

[Back](./ReadMe.md)

Delete images
=============

Estimated reading time: 2 minutes

> This topic applies to Docker Enterprise.
>
> The Docker Enterprise platform business, including products, customers, and employees, has been acquired by Mirantis, inc., effective 13-November-2019. For more information on the acquisition and how it may affect you and your business, refer to the [Docker Enterprise Customer FAQ](https://www.docker.com/faq-for-docker-enterprise-customers-and-partners).

To delete an image, navigate to the Tags tab of the repository page on the DTR web interface. In the Tags tab, select all the image tags you want to delete, and click the Delete button.

![](https://docs.docker.com/ee/dtr/images/delete-images-1.png)

You can also delete all image versions by deleting the repository. To delete a repository, navigate to Settings and click Delete under "Delete Repository".

Delete signed images[](https://docs.docker.com/ee/dtr/user/manage-images/delete-images/#delete-signed-images)
-------------------------------------------------------------------------------------------------------------

DTR only allows deleting images if the image has not been signed. You first need to delete all the trust data associated with the image before you are able to delete the image.

![](https://docs.docker.com/ee/dtr/images/delete-images-2.png)

There are three steps to delete a signed image:

1.  Find which roles signed the image.
2.  Remove the trust data for each role.
3.  The image is now unsigned, so you can delete it.

### Find which roles signed an image[](https://docs.docker.com/ee/dtr/user/manage-images/delete-images/#find-which-roles-signed-an-image)

To find which roles signed an image, you first need to learn which roles are trusted to sign the image.

[Set up your Notary client](https://docs.docker.com/ee/dtr/user/manage-images/sign-images/#configure-your-notary-client), and run:

```
notary delegation list dtr-example.com/library/wordpress

```

In this example, the repository owner delegated trust to the `targets/releases` and `targets/qa` roles:

```
ROLE                PATHS             KEY IDS                                                             THRESHOLD
----                -----             -------                                                             ---------
targets/releases    "" <all paths>    c3470c45cefde5447cf215d8b05832b0d0aceb6846dfa051db249d5a32ea9bc8    1
targets/qa          "" <all paths>    c3470c45cefde5447cf215d8b05832b0d0aceb6846dfa051db249d5a32ea9bc8    1

```

Now that you know which roles are allowed to sign images in this repository, you can learn which roles actually signed it:

```
# Check if the image was signed by the "targets" role
notary list dtr-example.com/library/wordpress

# Check if the image was signed by a specific role
notary list dtr-example.com/library/wordpress --roles <role-name>

```

In this example the image was signed by three roles: `targets`, `targets/releases`, and `targets/qa`.

### Remove trust data for a role[](https://docs.docker.com/ee/dtr/user/manage-images/delete-images/#remove-trust-data-for-a-role)

Once you know which roles signed an image, you'll be able to remove trust data for those roles. Only users with private keys that have the roles are able to do this operation.

For each role that signed the image, run:

```
notary remove dtr-example.com/library/wordpress <tag>\
  --roles <role-name> --publish

```

Once you've removed trust data for all roles, DTR shows the image as unsigned. Then you can delete it.