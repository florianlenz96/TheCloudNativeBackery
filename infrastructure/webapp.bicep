@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param appName string = 'acr${uniqueString(resourceGroup().id)}'

@description('Provide a location for the registry.')
param location string = resourceGroup().location

param sku string = 'B1'

param containerImage string
param acrLoginServer string

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${appName}-plan'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: '${appName}-web'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrLoginServer}/${containerImage}'
      acrUseManagedIdentityCreds: true
      alwaysOn: true
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output appName string = appService.name
