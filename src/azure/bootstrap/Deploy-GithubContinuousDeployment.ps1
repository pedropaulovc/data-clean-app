#!/usr/bin/env pwsh
param (
    [string] $Subscription = 'e73dc189-6641-4f1a-bc8a-788ea80fdaa0',
    [string] $ProjectName = 'dataclean',
    [string] $Region = 'westus2',
    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $Environment = 'dev'
)

$ErrorActionPreference = 'Stop'

az ad sp create-for-rbac `
    --name "sp-$ProjectName-github-$Environment" `
    --role Contributor `
    --scopes "/subscriptions/$Subscription/resourceGroups/rg-$ProjectName-deploy-$Environment" "/subscriptions/$Subscription/resourceGroups/rg-$ProjectName-$Region-$Environment" `
    --sdk-auth true