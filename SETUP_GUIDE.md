# CI/CD Setup Guide - GitHub Actions + Azure

## 📦 Project Files Created

Your project structure is now ready:

```
/CICD automation
 ├── main.bicep
 ├── parameters.json
 └── .github/workflows/deploy.yml
```

---

## 🚀 NEXT STEPS TO ENABLE CI/CD

### STEP 1: Initialize Git Repository (Local)

```powershell
cd "C:\Users\ShingalaKaranSureshb\Documents\CICD automation"
git init
git add .
git commit -m "Initial commit: CI/CD setup"
```

### STEP 2: Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Click **New repository**
3. Name it: `cicd-azure-deployment`
4. **Do NOT initialize** with README (you already have files)
5. Click **Create repository**

### STEP 3: Push Code to GitHub

```powershell
git remote add origin https://github.com/<YOUR-USERNAME>/cicd-azure-deployment.git
git branch -M main
git push -u origin main
```

---

## 🔐 STEP 4: Create Azure Service Principal

**Run this command in PowerShell locally:**

```powershell
az ad sp create-for-rbac --name "github-action-sp" --role contributor `
--scopes /subscriptions/<YOUR-SUBSCRIPTION-ID> `
--sdk-auth
```

**To find your subscription ID:**

```powershell
az account list --output table
```

✅ **Copy the entire JSON output**

---

## 🔑 STEP 5: Add GitHub Secret

1. Go to your GitHub repo
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. **Name:** `AZURE_CREDENTIALS`
5. **Value:** Paste the JSON from Step 4
6. Click **Add secret**

---

## ▶️ STEP 6: Test the Pipeline

1. Make a small change to any file (e.g., add a comment to `main.bicep`)
2. Commit and push:

```powershell
git add .
git commit -m "Trigger CI/CD pipeline"
git push
```

3. Go to GitHub → **Actions** tab
4. Watch the pipeline run ✨
5. Check Azure Portal → Resource Groups → `myRG` to verify deployment

---

## 🎯 What Happens When You Push

| Step | Action |
|------|--------|
| 1. Push to main | Pipeline triggers automatically |
| 2. Checkout code | GitHub downloads your files |
| 3. Login to Azure | Uses AZURE_CREDENTIALS secret |
| 4. Create Resource Group | Creates `myRG` in Azure (eastus region) |
| 5. Deploy Bicep | Deploys storage account |
| 6. Show Output | Displays deployment results |

---

## 📊 Storage Account Details

- **Name:** `mystorage<unique-hash>`
- **Type:** StorageV2
- **SKU:** Standard_LRS (Locally Redundant Storage)
- **Access Tier:** Hot
- **Location:** East US

---

## 🔧 Customization Tips

### Change Region
Edit `.github/workflows/deploy.yml`:
```yaml
az group create --name myRG --location westus  # Change to your region
```

### Change Resource Group Name
Edit both:
- `.github/workflows/deploy.yml` - Change `myRG` 
- `parameters.json` - If you add it as a parameter

### Add More Resources
Edit `main.bicep` to add additional resources (VMs, databases, networks, etc.)

---

## 🐛 Troubleshooting

| Error | Solution |
|-------|----------|
| `Invalid credentials` | Re-run service principal command & update GitHub secret |
| `No subscription found` | Check subscription ID is correct |
| `Resource already exists` | Storage names must be globally unique; Bicep handles this with `uniqueString()` |
| `Access Denied` | Ensure service principal has Contributor role on subscription |

---

## 📚 Resources

- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [GitHub Actions for Azure](https://github.com/Azure/actions)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/)

---

## ✅ Success Checklist

- [ ] Git repo initialized locally
- [ ] GitHub repo created
- [ ] Code pushed to main branch
- [ ] Service principal created
- [ ] AZURE_CREDENTIALS secret added
- [ ] Pipeline executed successfully
- [ ] Resource Group appears in Azure Portal
- [ ] Storage Account deployed

---

🎉 **You now have a fully automated CI/CD pipeline!**
