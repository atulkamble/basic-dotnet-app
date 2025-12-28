# 🚀 Azure Web App Deployment Setup Guide

## Overview
This guide helps you deploy your .NET application to Azure Web App Service using Azure Pipelines.

## 📋 Prerequisites

### 1. Azure Resources Required
- **Azure Subscription** (active)
- **Resource Group** (e.g., `rg-basic-dotnet-webapp`)
- **Azure Web App Service** (e.g., `basic-modern-dotnet-webapp`)
- **App Service Plan** (e.g., `asp-basic-dotnet-webapp`)

### 2. Azure DevOps Setup
- **Azure DevOps Project**
- **Service Connection** to Azure
- **Pipeline** configured with this repository

## 🏗️ Step 1: Deploy Azure Infrastructure

### Option A: Using Azure CLI (Recommended)
```bash
# Login to Azure
az login

# Create Resource Group
az group create --name rg-basic-dotnet-webapp --location "East US"

# Create App Service Plan
az appservice plan create \
  --name asp-basic-dotnet-webapp \
  --resource-group rg-basic-dotnet-webapp \
  --sku B1 \
  --is-linux

# Create Web App
az webapp create \
  --name basic-modern-dotnet-webapp \
  --resource-group rg-basic-dotnet-webapp \
  --plan asp-basic-dotnet-webapp \
  --runtime "DOTNETCORE|10.0"
```

### Option B: Using ARM Template
```bash
# Deploy using the existing ARM template
az deployment group create \
  --resource-group rg-basic-dotnet-webapp \
  --template-file azure-infrastructure.json \
  --parameters webAppName=basic-modern-dotnet-webapp
```

## 🔗 Step 2: Create Azure Service Connection

### In Azure DevOps:

1. **Go to Project Settings** → **Service Connections**
2. **Click "New Service Connection"**
3. **Select "Azure Resource Manager"**
4. **Choose "Service principal (automatic)"**
5. **Configure:**
   - **Subscription**: Your Azure subscription
   - **Resource Group**: `rg-basic-dotnet-webapp`
   - **Service Connection Name**: `Azure-BasicDotnetApp-Connection`
6. **Save** the connection

### Alternative: Manual Service Principal Setup
```bash
# Create service principal
az ad sp create-for-rbac --name "BasicDotnetApp-SP" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/rg-basic-dotnet-webapp
```

## ⚙️ Step 3: Configure Pipeline Parameters

### Method 1: Pipeline UI (Recommended)
When running the pipeline in Azure DevOps:

1. **Click "Run Pipeline"**
2. **Set Parameters:**
   - ✅ `enableDeployment`: **true**
   - 📝 `azureServiceConnection`: **Azure-BasicDotnetApp-Connection**
   - 🌐 `webAppName`: **your-unique-webapp-name**
   - 📦 `resourceGroupName`: **rg-basic-dotnet-webapp**
3. **Run** the pipeline

### Method 2: Update Default Values
Edit the pipeline file and change default parameter values:
```yaml
parameters:
- name: enableDeployment
  displayName: 'Enable Deployment to Azure'
  type: boolean
  default: true  # Changed from false
- name: webAppName
  displayName: 'Azure Web App Name'
  type: string
  default: 'your-unique-webapp-name'  # Change this
```

## 🚀 Step 4: Run the Pipeline

### First Run (Build Only)
1. **Keep** `enableDeployment = false` for testing
2. **Verify** build completes successfully
3. **Check** build artifacts are created

### Deployment Run
1. **Set** `enableDeployment = true`
2. **Verify** all parameters are correct
3. **Run** the pipeline
4. **Monitor** deployment progress

## 🌐 Step 5: Verify Deployment

### Check Your Application
- **URL**: `https://your-webapp-name.azurewebsites.net`
- **Azure Portal**: Monitor in App Service blade
- **Logs**: Check Application Insights or Log Stream

### Pipeline Success Indicators
✅ Build stage completes  
✅ Artifacts published  
✅ Deployment stage runs  
✅ Azure Web App updated  
✅ Application restarted  

## 🎯 Pipeline Features

### Build Stage
- .NET 10 SDK installation
- NuGet package restoration
- Application compilation
- Build verification
- Artifact creation

### Deployment Stage (when enabled)
- Artifact download
- Azure Web App deployment
- Application restart
- Deployment verification
- Success confirmation

## 🔧 Troubleshooting

### Common Issues

**Service Connection Error**
```
Error: Could not find service connection 'Azure-BasicDotnetApp-Connection'
```
→ Create service connection in Azure DevOps Project Settings

**Web App Not Found**
```
Error: Web App 'basic-modern-dotnet-webapp' not found
```
→ Ensure Azure Web App exists and name matches parameter

**Deployment Fails**
```
Error: Deployment to Azure Web App failed
```
→ Check service connection permissions and resource group access

**Build Artifacts Missing**
```
Error: Could not find build artifacts
```
→ Ensure build stage completes successfully before deployment

### Debug Steps
1. **Check Azure Resources** exist
2. **Verify Service Connection** permissions
3. **Review Pipeline Logs** for specific errors
4. **Test Service Connection** in Azure DevOps
5. **Check Resource Group** access permissions

## 📊 Monitoring & Next Steps

### After Successful Deployment
1. **Monitor Application Performance**
2. **Set up Application Insights**
3. **Configure Monitoring Alerts**
4. **Review Security Settings**
5. **Set up Custom Domains** (if needed)

### Continuous Deployment
- Pipeline triggers on `main` and `develop` branches
- Automatic deployment when `enableDeployment = true`
- Staged deployments with build verification

---

## 🎉 Success!
Your .NET application is now deployed to Azure Web App Service! 

**Application URL**: `https://your-webapp-name.azurewebsites.net`

The pipeline will automatically deploy future commits when deployment is enabled.