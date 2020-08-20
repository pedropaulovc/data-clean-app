`DataCleanContinuousDeployment.json` is the resource group-level deployment assets template.

Responsibilities
================
* Creates the storage account to hold official releases before safe rollout via ADM
* Creates the ADM service topology
* Triggers the ADM safe rollout process

Deployment steps
================
1. Run `az deployment group create --resource-group <resource group> --template-file BootstrapResourceGroup.json --parameters BootstrapResourceGroup.parameters.json --location <region>`
