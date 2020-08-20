#!/usr/bin/env pwsh

$currentUserObjectId = az ad signed-in-user show --query objectId --output tsv

Write-Host -MessageData "Granting 'User Access Administrator' and 'Owner (scope = /)' roles"
az rest --method post --url "/providers/Microsoft.Authorization/elevateAccess?api-version=2016-07-01"
az role assignment create --role "Owner" --scope "/" --assignee $currentUserObjectId
