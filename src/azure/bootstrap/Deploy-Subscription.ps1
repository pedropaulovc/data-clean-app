#!/usr/bin/env pwsh
param (
    [string] $Region = 'westus2',
    [string] $ProjectName = 'dataclean',

    [ValidateSet('dev','uat','ppe', 'prd')]
    [string] $Environment = 'dev'
)

$ErrorActionPreference = 'Stop'

az deployment sub create --template-file DataCleanSubscription.json --parameters DataCleanSubscription.parameters.json --location $Region
