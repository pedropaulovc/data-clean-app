#!/usr/bin/env pwsh

param (
    [string] $DeploymentResourceGroupPrefix = "rg-dataclean-deploy",

    [Parameter(Mandatory=$true)]
    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $Environment
)

$ErrorActionPreference = 'Stop'

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module powershell-yaml

$templateName = "DataCleanContinuousDeployment";
$resourceGroupName = $DeploymentResourceGroupPrefix + '-' + $Environment;
$deploymentName = $templateName + '-' + $Environment + "-" + (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmm');
$templateFile = Join-Path $PSScriptRoot "$templateName.json";
$templateParameters = Join-Path $PSScriptRoot "$templateName.parameters.json";

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameters --name $deploymentName `
    | ConvertFrom-Json `
    | ConvertTo-Yaml
