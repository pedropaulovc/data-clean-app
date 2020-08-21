#!/usr/bin/env pwsh

$currentUserObjectId = az ad signed-in-user show --query objectId --output tsv

Write-Host -MessageData "Revoking 'User Access Administrator' and 'Owner (scope = /)' roles" -ForegroundColor Green
az role assignment delete --role "User Access Administrator" --scope "/" --assignee $currentUserObjectId
az role assignment delete --role "Owner" --scope "/" --assignee $currentUserObjectId
