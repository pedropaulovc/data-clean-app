param (
    [string] $deploymentResourceGroupPrefix = "rg-dataclean-deploy",

    [Parameter(Mandatory=$true)]
    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $environment
)

$resourceGroupName = $deploymentResourceGroupPrefix + '-' + $environment;
$templateFile = Join-Path $PSScriptRoot "DataCleanContinuousDeployment.json";
$templateParameters = Join-Path $PSScriptRoot "DataCleanContinuousDeployment.parameters.json";

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameters
