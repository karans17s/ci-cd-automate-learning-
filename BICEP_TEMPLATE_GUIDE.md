# 🏗️ Azure Bicep Template Guide - Storage Accounts

## 📚 Table of Contents
1. [Current Template Explanation](#current-template-explanation)
2. [Component Breakdown](#component-breakdown)
3. [Storage Account Kinds](#storage-account-kinds)
4. [Complete Examples](#complete-examples)

---

## 📖 Current Template Explanation

### What Does This Template Do?

This Bicep template **deploys an Azure Storage Account** to your Azure resource group. It's an Infrastructure-as-Code (IaC) approach to deployment rather than manual Azure Portal clicks.

```bicep
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
```

---

## 🔍 Component Breakdown

### 1️⃣ **Parameter Declaration**
```bicep
param location string = resourceGroup().location
```
- **`param`** - Declares an input parameter
- **`location string`** - Accepts a string value for Azure region
- **`= resourceGroup().location`** - Default value (uses the resource group's location)

**Example values:** `eastus`, `westus`, `northeurope`, `southeastasia`

---

### 2️⃣ **Resource Declaration**
```bicep
resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
```
- **`resource`** - Declares a new Azure resource
- **`storage`** - Local name for this resource (used within template)
- **`Microsoft.Storage/storageAccounts@2021-09-01`** - Azure resource type & API version
- **`@2021-09-01`** - Specific API version (ensures compatibility)

---

### 3️⃣ **Name Property**
```bicep
name: 'mystorage${uniqueString(resourceGroup().id)}'
```
- **`mystorage`** - Prefix (your custom name)
- **`${uniqueString(resourceGroup().id)}`** - Generates a unique suffix
- **Why?** Storage account names must be **globally unique** across all Azure

**Example output:** `mystorageabcd1234xyz`

---

### 4️⃣ **Location Property**
```bicep
location: location
```
- Sets where the storage account is deployed
- Uses the `location` parameter value

---

### 5️⃣ **SKU (Stock Keeping Unit)**
```bicep
sku: {
  name: 'Standard_LRS'
}
```
- **`Standard_LRS`** - Performance tier and replication strategy
  - **Standard** - General purpose, good for most use cases
  - **LRS** - Locally Redundant Storage (3 copies in same region)

**Other SKU options:**
- `Standard_GRS` - Geo-Redundant (3 copies primary + 3 copies secondary region)
- `Standard_RAGRS` - Read-Access Geo-Redundant
- `Premium_LRS` - High-performance (for specific workloads)

---

### 6️⃣ **Kind Property**
```bicep
kind: 'StorageV2'
```
- **`StorageV2`** - General Purpose v2 (most flexible, supports all services)
- Supports: Blobs, Files, Queues, Tables
- **Recommended for most cases** ✅

---

### 7️⃣ **Properties**
```bicep
properties: {
  accessTier: 'Hot'
}
```
- **`accessTier: 'Hot'`** - Data access performance
  - **Hot** - Frequent access (higher cost, lower latency)
  - **Cool** - Infrequent access (lower cost, higher latency)
  - **Archive** - Long-term storage (lowest cost, longest latency)

---

### 8️⃣ **Outputs**
```bicep
output storageId string = storage.id
output storageName string = storage.name
```
- Returns deployment results to GitHub Actions or other tools
- **`storageId`** - Full Azure Resource ID
- **`storageName`** - Storage account name (useful for DNS)

---

## 📦 Storage Account Kinds

| Kind | Use Case | SKU | Access Tier | Services |
|------|----------|-----|-------------|----------|
| **StorageV2** | General purpose ⭐ | Standard/Premium | Hot/Cool | All |
| **BlobStorage** | Blob-only | Standard | Hot/Cool | Blobs only |
| **BlockBlobStorage** | Premium blobs | Premium | Hot/Cool | Block blobs |
| **FileStorage** | Premium file shares | Premium | Hot/Cool | Files only |
| **Storage** | Legacy GP v1 | Standard | N/A | All (older) |
| **QueueStorage** | Message queues | Standard | N/A | Queues only |
| **TableStorage** | NoSQL tables | Standard | N/A | Tables only |

---

## 🎯 Complete Examples

### ✅ Example 1: StorageV2 (Current - Recommended)

```bicep
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
```

**✨ Best for:** Everything (blobs, files, queues, tables)

---

### 🚀 Example 2: BlockBlobStorage (Premium - High Performance)

```bicep
param location string = resourceGroup().location

resource storagePremium 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'premblob${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Premium_LRS'  // ⚠️ Must use Premium with BlockBlobStorage
  }
  kind: 'BlockBlobStorage'
  properties: {
    accessTier: 'Hot'
  }
}

output blockStorageId string = storagePremium.id
output blockStorageName string = storagePremium.name
```

**✨ Best for:** 
- High-performance applications
- Large file uploads
- Machine learning workloads

---

### 📁 Example 3: FileStorage (Premium File Shares)

```bicep
param location string = resourceGroup().location

resource fileStorage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'fileshare${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Premium_LRS'  // Required for FileStorage
  }
  kind: 'FileStorage'
  properties: {
    accessTier: 'Hot'
  }
}

output fileStorageId string = fileStorage.id
output fileStorageName string = fileStorage.name
```

**✨ Best for:**
- Premium file shares
- Enterprise NFS/SMB shares
- Database backups

---

### 💰 Example 4: BlobStorage (Cost-Optimized)

```bicep
param location string = resourceGroup().location

resource blobStorage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'blobonly${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'BlobStorage'
  properties: {
    accessTier: 'Cool'  // Lower cost for infrequent access
  }
}

output blobStorageId string = blobStorage.id
output blobStorageName string = blobStorage.name
```

**✨ Best for:**
- Blob storage only
- Lower cost requirements
- Archive/backup data

---

### 📊 Example 5: Multiple Storage Accounts (Production)

```bicep
param location string = resourceGroup().location
param environment string = 'dev'  // dev, staging, prod

// General Purpose Storage
resource storagev2 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'gp${environment}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// Archive Storage for backups
resource archiveStorage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'arch${environment}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'BlobStorage'
  properties: {
    accessTier: 'Archive'  // Cheapest, slowest access
  }
}

// Premium File Shares
resource premiumFiles 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'prem${environment}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'FileStorage'
  properties: {
    accessTier: 'Hot'
  }
}

output gpStorageName string = storagev2.name
output archiveStorageName string = archiveStorage.name
output premiumFilesName string = premiumFiles.name
```

**✨ Best for:** Production environments with multiple storage needs

---

## 🔧 How to Deploy

### 1. Local Deployment
```bash
az group create --name myRG --location eastus
az deployment group create \
  --resource-group myRG \
  --template-file main.bicep \
  --parameters location=eastus
```

### 2. Via GitHub Actions (Automated)
The workflow automatically:
```yaml
az deployment group create \
  --resource-group myRG \
  --template-file main.bicep \
  --parameters parameters.json
```

---

## 📊 Cost Comparison

| Kind | SKU | Access Tier | Monthly Cost (1TB) |
|------|-----|-------------|-------------------|
| StorageV2 | Standard_LRS | Hot | ~$23 |
| StorageV2 | Standard_LRS | Cool | ~$10 |
| BlobStorage | Standard_LRS | Cool | ~$10 |
| BlockBlobStorage | Premium_LRS | Hot | ~$280 |
| FileStorage | Premium_LRS | Hot | ~$280 |

💡 **Tip:** Use `Cool` or `Archive` tiers for backup/archive data to save costs!

---

## ✅ Best Practices

1. **Use StorageV2 by default** - Most flexible, future-proof ⭐
2. **Use unique names** - `uniqueString()` prevents conflicts
3. **Set appropriate access tiers** - Hot for active, Cool/Archive for backups
4. **Use Standard SKU** - Unless you need Premium performance
5. **Enable soft delete** - Add to properties for data recovery
6. **Use parameters** - Make templates reusable across environments

---

## 🚀 Next Steps

1. **Test locally:**
   ```bash
   az deployment group create \
     --resource-group myRG \
     --template-file main.bicep
   ```

2. **Push to GitHub:**
   ```bash
   git add main.bicep
   git commit -m "Update Bicep template"
   git push
   ```

3. **Watch CI/CD deploy automatically** ✨

---

## 📚 References

- [Azure Bicep Docs](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Storage Account Types](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [SKU Comparison](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview#performance-tiers)
- [Pricing](https://azure.microsoft.com/en-us/pricing/details/storage/)

---

## 💡 Quick Decision Tree

```
Do you need...

├─ Everything (blobs, files, tables, queues)?
│  └─ Use StorageV2 ✅
│
├─ Only Blobs?
│  ├─ High performance?
│  │  └─ Use BlockBlobStorage ⚡
│  └─ Cost-sensitive?
│     └─ Use BlobStorage 💰
│
├─ Only File Shares?
│  ├─ Premium required?
│  │  └─ Use FileStorage 📁
│  └─ Standard ok?
│     └─ Use StorageV2 ✅
│
└─ Legacy system?
   └─ Use Storage (v1) 🗂️
```

---

🎉 **You now have a complete Bicep storage account template guide!**
