// parameters
param location string = resourceGroup().location
param tenantId string = subscription().tenantId
param serverName string
param databaseName string
param adminUserPrincipalName string
param adminUserId string
param whitelistIp string

// create the SQL server
resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: adminUserPrincipalName
      sid: adminUserId
      tenantId: tenantId
      azureADOnlyAuthentication: true
    }
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource sqlServer_advancedThreatProtectionSettings 'Microsoft.Sql/servers/advancedThreatProtectionSettings@2024-05-01-preview' = {
  parent: sqlServer
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource sqlServer_connectionPolicies 'Microsoft.Sql/servers/connectionPolicies@2024-05-01-preview' = {
  parent: sqlServer
  name: 'default'
  properties: {
    connectionType: 'Default'
  }
}

resource sqlServer_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource sqlServer_whiteListMyIp 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: sqlServer
  name: 'OwnerClientIp'
  properties: {
    startIpAddress: whitelistIp
    endIpAddress: whitelistIp
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    autoPauseDelay: 60
    requestedBackupStorageRedundancy: 'Geo'
    minCapacity: json('0.5')
    isLedgerOn: false
    availabilityZone: 'NoPreference'
  }
}


// outputs
output sqlServerName string = sqlServer.name
output sqlDatabaseName string = sqlDatabase.name
// output sqlConnectionString string = 'Server=tcp:${sqlServer.name}.database.windows.net,1433;Initial Catalog=${sqlDatabase.name};Persist Security Info=False;User ID=${adminUsername};Password=${adminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
