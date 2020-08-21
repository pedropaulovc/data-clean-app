There are 4 bootstrap templates to be applied, each one is responsible for one scope level of the Azure resource
hierarchy. The deployment templates are meant to be deployed in the sequence listed below. At each step, make
sure to review the parameters before triggering the deployment.

Pre-requisites
==============
* PowerShell Core installed
* An Azure subscription
* Azure CLI installed
* Tenant admin credentials

Tenant level
============
`DataCleanTenant.json` is the tenant-level deployment template.

Responsibilities
----------------
* Creates the `mg-dataclean` management group

Deployment steps
----------------
The tenant level template requires privileges that not even the tenant administrator has by default and that can't be
assigned via ARM templates, we have a couple PowerShell scripts to workaround this:

1. Run `az login` as the tenant admin
2. Run `./Grant-TenantDeploymentRoles.ps1`
3. Run `az deployment tenant create --template-file BootstrapTenant.json --parameters BootstrapTenant.parameters.json --location <region>`
4. Run `./Revoke-TenantDeploymentRoles.ps1`

Management group level
======================
`DataCleanManagementGroup.json` is the management group-level deployment template.

Responsibilities
----------------
* Moves the subscription under the management group
* Applies Azure security and operational policies (TODO)

Deployment steps
1. Run `az deployment mg create --management-group-id <management group>  --template-file DataCleanManagementGroup.json --parameters DataCleanManagementGroup.parameters.json --location <region>`

Subscription level
==================
`DataCleanSubscription.json` is the subscription-level deployment template.

Responsibilities
----------------
* Creates the resource group for continuous deployment assets
* Creates an user assigned managed identity to be used by the [Azure Deployment Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-manager-overview) (ADM)
* Grants Contributor role at the subscription level to the managed identity

Deployment steps
----------------
1. Run `az deployment sub create --template-file BootstrapSubscription.json --parameters BootstrapSubscription.parameters.json --location <region>`

Resource group level
====================
`DataCleanResourceGroup.json` is the resource group-level deployment template.

Responsibilities
----------------
* Creates the storage account to hold official releases before safe rollout via ADM
* Creates the ADM service topology

Deployment steps
----------------
1. Run `az deployment group create --resource-group <resource group> --template-file BootstrapResourceGroup.json --parameters BootstrapResourceGroup.parameters.json --location <region>`