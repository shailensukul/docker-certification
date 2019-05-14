# Docker Examples

## Azure App Service for Linux

In this example, we will deploy the official Docker container for the Ghost blog engine and host a highly available instance with a Azure database for MySQL, Azure Storage for static content and Azure App Service

Here is the high level plan:

* Create a resource group
* Create a Table Storage instance
* Create an Azure MySQL server
* Generate a Lets Encrypt certificate for your custom url
* Create an Azure App Service Plan
* Create an Azure App Service and provision the service from the official Docker image and configure it using environment variables
* Add a custom domain to the Azure App Service & add a certificate to the SSL binding
* Login into Ghost and set the root user account

Let's get started:

## Steps / Instructions 

**Login into Azure & select the subscription**

``` 
az login
az account set -s <subscription guid>
``` 
**Create a resource group**
```
az group create --name <myresourcegroup> --location "Australia Southeast"
```

**Create Storage Account**
```
az storage account create --location "Australia Southeast" --name <storageaccountname> --resource-group <myresourcegroup> --access-tier Hot --default-action Allow --kind StorageV2 --sku Standard_GRS
```

Note the access key

**Create Azure MySQL server and database**
```
az mysql server create --admin-password <adminPassword> --admin-user <adminUser> --name <mysqlservername> --resource-group <myresourcegroup> --sku-name B_Gen5_1 --version 5.7 --location "Australia Southeast" --ssl-enforcement Enabled --storage-size 5120
```
```
az mysql db create --resource-group <myresourcegroup> --server-name <mysqlservername> --name <dbname>
```

**Generate a Lets Encrypt certificate**
