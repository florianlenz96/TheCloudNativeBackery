targetScope = 'subscription'

@description('environment')
param environment string = 'dev'

@description('Name of the Project')
param projectName string = 'CloudNativeBakery'

@description('Location of the Resource Group')
param location string = 'westeurope'

var resourceGroupName = 'rg-${projectName}-${environment}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module containerRegistryModule './containerRegistry.bicep' = {
  name: 'containerRegistryModule'
  scope: rg
  params: {
    acrName: 'acr${projectName}${environment}'
  }
}

module webAppModule './webapp.bicep' = {
  name: 'webAppModule'
  scope: rg
  params: {
    appName: '${projectName}-${environment}'
    location: location
    containerImage: 'backeryonlineshop:latest'
    acrLoginServer: containerRegistryModule.outputs.acrLoginServer
  }
}

module webAppAcrRoleModule './webappAcrRole.bicep' = {
  name: 'webAppAcrRoleModule'
  scope: rg
  params: {
    appName: webAppModule.outputs.appName
    acrName: containerRegistryModule.outputs.acrName
  }
}

output containerRegistryName string = containerRegistryModule.outputs.acrName
output webAppName string = webAppModule.outputs.appName
output resourceGroupName string = rg.name
