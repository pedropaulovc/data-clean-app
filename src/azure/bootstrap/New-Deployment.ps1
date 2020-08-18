Write-Information "Login to Azure"

az login

az account list --output table

$subscription = Read-Host "Select the desired subscription"
az account set --subscription $subscription