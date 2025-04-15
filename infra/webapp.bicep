param webAppName string
param sku string = 'S1'
param location string = resourceGroup().location

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true // Ensure Linux compatibility
  }
  sku: {
    name: sku
    capacity: 1 // Specify the capacity if required
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|7.0' // Adjust runtime version if 8.0 is unsupported
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
        // Add additional app settings as needed
      ]
    }
  }
}
