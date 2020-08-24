#!/usr/bin/env pwsh
param (
    [string] $ManagementGroup = "mg-dataclean",
    [string] $Region = "westus2"
)

$ErrorActionPreference = 'Stop'

az deployment mg create --management-group-id $ManagementGroup --template-file DataCleanManagementGroup.json --parameters DataCleanManagementGroup.parameters.json --location $Region;