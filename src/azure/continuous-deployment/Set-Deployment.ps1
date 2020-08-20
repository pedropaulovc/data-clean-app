param (
    [string] $deploymentResourceGroupPrefix = "rg-dataclean-deploy",

    [Parameter(Mandatory=$true)]
    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $environment
)

$templateName = "DataCleanContinuousDeployment";
$resourceGroupName = $deploymentResourceGroupPrefix + '-' + $environment;
$deploymentName = $templateName + '-' + $environment;
$templateFile = Join-Path $PSScriptRoot "$templateName.json";
$templateParameters = Join-Path $PSScriptRoot "$templateName.parameters.json";

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameters --name $deploymentName
