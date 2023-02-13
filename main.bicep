param location string = 'northeurope'
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}x'
param appServiceName string = 'toylaunch${uniqueString(resourceGroup().id)}x'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'toylaunchstorage01x'
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot' 
  }
}

module appService './modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceName: appServiceName
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
