param location string = resourceGroup().location

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'mystorage${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output storageId string = storage.id
output storageName string = storage.name
