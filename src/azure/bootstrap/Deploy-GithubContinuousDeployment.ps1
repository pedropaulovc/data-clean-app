#!/usr/bin/env pwsh
param (
    [string] $Subscription = 'e73dc189-6641-4f1a-bc8a-788ea80fdaa0',
    [string] $ProjectName = 'dataclean',
    [string] $Region = 'westus2',
    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $Environment = 'dev'
)

$ErrorActionPreference = 'Stop'

$servicePrincipalJson = az ad sp create-for-rbac `
    --name "sp-$ProjectName-github-$Environment" `
    --role Contributor `
    --scopes "/subscriptions/$Subscription/resourceGroups/rg-$ProjectName-deploy-$Environment" "/subscriptions/$Subscription/resourceGroups/rg-$ProjectName-$Region-$Environment" `
    --sdk-auth true

$servicePrincipal = $servicePrincipalJson | ConvertFrom-Json
$servicePrincipalId = az ad sp show --id $servicePrincipal.clientId | ConvertFrom-Json | Select-Object -ExpandProperty objectId
$directoryWriteRoleTemplateId = '9360feb5-f418-4baa-8175-e2a00bac4301';

$roles = az rest `
    --method get `
    --url "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments?`$filter = principalId eq '$servicePrincipalId'" `
    | ConvertFrom-Json

$hasDirectoryWriteRole = ($roles.value | Where-Object { $_.roleDefinitionId -eq $directoryWriteRoleTemplateId}).Count -gt 0;
if (-not $hasDirectoryWriteRole) {
    az rest `
        --method post `
        --url "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments?$filter = principalId eq 'f1847572-48aa-47aa-96a3-2ec61904f41f'" `
        --body "{`"principalId`": `"$servicePrincipalId`", `"roleDefinitionId`": `"$directoryWriteRoleTemplateId`", `"resourceScope`": `"/`"}" `
        --headers "Content-Type=application/json"
}

$servicePrincipalJson