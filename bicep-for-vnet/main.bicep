@allowed([
  'nonprod'
  'prod'
])
param environmentType string

param location string = resourceGroup().location

param vnetName string
param addressPrefix string
param subnetName string
param subnetAddressPrefix string

param storageAccountName string

param appServicePlanName string
param appServiceAppName string

module vnet 'vnet.bicep' = {
  name: vnetName
  params: {
    location: location
    vnetName: vnetName
    addressPrefix: addressPrefix
    subnetName: subnetName
    subnetAddressPrefix: subnetAddressPrefix
  }
}

module storageAccount 'storage.bicep' = {
  name: '${storageAccountName}${uniqueString(resourceGroup().id)}'
  params: {
    storageAccountName: '${storageAccountName}${uniqueString(resourceGroup().id)}'
    location: location
    environmentType: environmentType
  }
}

module appService 'appService.bicep' = {
  name: '${appServiceAppName}${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    appServiceAppName: '${appServiceAppName}${uniqueString(resourceGroup().id)}'
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
