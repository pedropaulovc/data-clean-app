#!/usr/bin/env pwsh
param (
    [string] $Region = 'westus2',
    [string] $ProjectName = 'dataclean',

    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $Environment = 'dev'
)

$ErrorActionPreference = 'Stop'

# TODO: AKS admin group name should be unique per (region, subscription, resource group, project, environment) #6
$aksAdminSecurityGroupName = 'sg-admin-aks-' + $ProjectName + '-' + $Region + '-' + $Environment;
az ad group create --display-name $aksAdminSecurityGroupName --mail-nickname $aksAdminSecurityGroupName

az deployment sub create --template-file DataCleanSubscription.json --parameters DataCleanSubscription.parameters.json --location $Region
