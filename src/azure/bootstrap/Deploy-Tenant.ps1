#!/usr/bin/env pwsh
param (
    [string] $Region = "westus2"
)

$ErrorActionPreference = 'Stop'

function Grant-TenantDeploymentRoles {
    param (
        [Parameter(Mandatory=$true)]
        [string] $currentUserObjectId
    )

    Write-Host "Elevating access to 'User Access Administrator'" -ForegroundColor Green
    az rest --method post --url "/providers/Microsoft.Authorization/elevateAccess?api-version=2016-07-01"
    
    Write-Host "Log back in again to refresh access token" -ForegroundColor Yellow
    az logout
    az login

    Write-Host "Granting 'Owner (scope = /)' role" -ForegroundColor Green
    az role assignment create --role "Owner" --scope "/" --assignee $currentUserObjectId
}

function Revoke-TenantDeploymentRoles {
    param (
        [Parameter(Mandatory=$true)]
        [string] $currentUserObjectId
    )

    Write-Host -MessageData "Revoking 'User Access Administrator' and 'Owner (scope = /)' roles" -ForegroundColor Green
    az role assignment delete --role "User Access Administrator" --scope "/" --assignee $currentUserObjectId
    az role assignment delete --role "Owner" --scope "/" --assignee $currentUserObjectId    
}

function Get-CurrentUser {
    return az ad signed-in-user show --query objectId --output tsv
}

$currentUserObjectId = Get-CurrentUser;

Grant-TenantDeploymentRoles($currentUserObjectId);
az deployment tenant create --template-file DataCleanTenant.json --parameters DataCleanTenant.parameters.json --location $region;
Revoke-TenantDeploymentRoles($currentUserObjectId);
