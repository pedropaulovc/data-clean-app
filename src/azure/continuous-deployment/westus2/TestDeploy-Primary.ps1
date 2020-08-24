#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

# $projectName = "dc" + (Get-Date).ToUniversalTime().ToString('HHmm');
$projectName = "dc1655";
$resourceGroup = "rg-" + $projectName + "-westus2-dev";

az group create --resource-group $resourceGroup --location westus2 | ConvertFrom-Json | ConvertTo-Yaml

az deployment group create --resource-group $resourceGroup --template-file ./DataCleanPrimary.json --parameters ./DataCleanPrimary.parameters.json "projectName=$projectName" | ConvertFrom-Json | ConvertTo-Yaml