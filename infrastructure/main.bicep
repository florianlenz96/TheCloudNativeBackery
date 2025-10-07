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
