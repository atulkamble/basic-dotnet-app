# 🔧 Quick Pipeline Setup Guide

## Issue Resolution: Service Connection Not Found

The pipeline is now configured to **build successfully** even without a service connection, but **deployment stages will be skipped** until you set up the Azure service connection.

## ✅ Current Status

- ✅ **Build Stage**: Will run successfully
- ✅ **Validation Stage**: Will check configuration
- ⏭️ **Deployment Stages**: Will be skipped (no errors)
- ℹ️ **Summary Stage**: Will show setup instructions

## 🚀 Quick Setup (Choose One Option)

### Option 1: Automated Setup (Recommended)
```bash
# Run the setup script to create service connection details
./setup-service-connection.sh

# Then follow the on-screen instructions to create the service connection in Azure DevOps
```

### Option 2: Manual Setup
1. **Go to Azure DevOps**:
   - Navigate to Project Settings → Service connections
   - Click "New service connection"
   - Choose "Azure Resource Manager"
   - Select "Service principal (automatic)"

2. **Configure Connection**:
   - **Name**: `Azure-BasicDotnetApp-Connection` (must match exactly)
   - **Subscription**: Select your Azure subscription
   - **Resource Group**: Select `rg-basic-dotnet-webapp`

3. **Test and Save**:
   - Click "Verify and save"
   - Ensure connection test passes

### Option 3: Use Different Connection Name
If you already have a service connection, update the pipeline variable:
```yaml
# In azure-pipelines.yml, change this line:
azureSubscription: 'Azure-BasicDotnetApp-Connection'
# To your actual service connection name:
azureSubscription: 'YOUR_EXISTING_CONNECTION_NAME'
```

## 🔄 After Setup

1. **Run Pipeline Again**: Deployments will now execute
2. **Check Logs**: Verify deployment stages run successfully
3. **Access App**: Visit your deployed web app

## 🎯 Pipeline Behavior

| Service Connection Status | Build | Deploy | Result |
|---------------------------|-------|---------|--------|
| ❌ Not configured | ✅ Runs | ⏭️ Skipped | Build artifacts created |
| ✅ Configured properly | ✅ Runs | ✅ Runs | Full deployment |
| ⚠️ Wrong name/invalid | ✅ Runs | ❌ Fails | Build succeeds, deploy fails |

## 📞 Need Help?

1. **Check validation stage** logs for detailed setup instructions
2. **Review deployment summary** stage for current status
3. **Verify resource group** exists: `rg-basic-dotnet-webapp`
4. **Confirm web app** exists: `basic-modern-dotnet-webapp`

---

**The pipeline is now robust and won't fail if the service connection isn't ready! 🎉**