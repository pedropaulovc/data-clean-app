#!/usr/bin/env pwsh

param (
    [string] $ProjectName = "dataclean",
    [string] $Region = "westus2",

    [Parameter(Mandatory=$true)]
    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $Environment
)

$ErrorActionPreference = 'Stop'

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module powershell-yaml

# TODO: AKS admin group name should be unique per (region, subscription, resource group, project, environment) #6
$aksAdminSecurityGroupName = 'sg-admin-aks-' + $ProjectName + '-' + $Region + '-' + $Environment;
$aksAdminSecurityGroupId = az ad group create --display-name $aksAdminSecurityGroupName --mail-nickname $aksAdminSecurityGroupName --query objectId --output tsv

$templateName = "DataCleanRuntime";
$resourceGroupName = 'rg-' + $ProjectName + '-' + $Region + '-' + $Environment;
$deploymentName = $templateName + "-" + (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmm');
$templateFile = Join-Path $PSScriptRoot "$templateName.json";
$templateParameters = Join-Path $PSScriptRoot "$templateName.parameters.json";

az deployment group create `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $templateParameters `
    --parameters "aksAdminSecurityGroupId=$aksAdminSecurityGroupId" `
    --name $deploymentName `
    | ConvertFrom-Json `
    | ConvertTo-Yaml
