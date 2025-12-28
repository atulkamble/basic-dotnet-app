# 🚀 Complete Deployment Guide: .NET Web App to Azure App Service

## 📋 Prerequisites Checklist

### ✅ Required Resources
- [ ] **Azure Subscription** (active)
- [ ] **Azure DevOps Organization** with project
- [ ] **Local development environment** with .NET 10 SDK

### ✅ Tools Needed
- [ ] Azure CLI installed
- [ ] Git configured
- [ ] Visual Studio Code or Visual Studio

---

## 🏗️ Step 1: Create Azure Resources

### Option A: Azure Portal (Recommended for Beginners)

1. **Login to Azure Portal**: [https://portal.azure.com](https://portal.azure.com)

2. **Create Resource Group**:
   - Search "Resource Groups" → Create
   - **Name**: `rg-basic-dotnet-webapp`
   - **Region**: `East US` (or your preferred region)

3. **Create App Service Plan**:
   - Search "App Service Plans" → Create
   - **Name**: `asp-basic-dotnet-webapp`
   - **Resource Group**: `rg-basic-dotnet-webapp`
   - **Operating System**: `Windows`
   - **Pricing Tier**: `Basic B1` (or Free F1 for testing)

4. **Create Web App**:
   - Search "App Services" → Create → Web App
   - **Name**: `basic-modern-dotnet-webapp-[YOUR-INITIALS]` (must be globally unique)
   - **Resource Group**: `rg-basic-dotnet-webapp`
   - **Runtime Stack**: `.NET 8` (closest to .NET 10)
   - **App Service Plan**: `asp-basic-dotnet-webapp`
   - **Region**: Same as resource group

### Option B: Azure CLI (Advanced Users)

```bash
# Login to Azure
az login

# Create Resource Group
az group create --name rg-basic-dotnet-webapp --location eastus

# Create App Service Plan
az appservice plan create \
  --name asp-basic-dotnet-webapp \
  --resource-group rg-basic-dotnet-webapp \
  --sku B1 \
  --is-windows

# Create Web App
az webapp create \
  --name basic-modern-dotnet-webapp-[YOUR-INITIALS] \
  --resource-group rg-basic-dotnet-webapp \
  --plan asp-basic-dotnet-webapp \
  --runtime "DOTNET|8.0"
```

📝 **Note your Web App URL**: `https://basic-modern-dotnet-webapp-[YOUR-INITIALS].azurewebsites.net`

---

## 🔑 Step 2: Create Azure DevOps Service Connection

### 2.1 In Azure DevOps Portal

1. **Navigate to Project Settings**:
   - Go to your Azure DevOps project
   - Click ⚙️ **Project Settings** (bottom left)

2. **Create Service Connection**:
   - Go to **Service connections** → **New service connection**
   - Select **Azure Resource Manager** → **Next**
   - Choose **Service principal (automatic)** → **Next**

3. **Configure Connection**:
   - **Scope Level**: `Subscription`
   - **Subscription**: Select your Azure subscription
   - **Resource Group**: `rg-basic-dotnet-webapp`
   - **Service connection name**: `Azure-BasicDotnetApp-Connection`
   - ✅ **Grant access permission to all pipelines**
   - Click **Save**

4. **Verify Connection**:
   - The connection should show ✅ **Ready**
   - If it shows ❌ **Error**, check your Azure permissions

---

## ⚙️ Step 3: Update Pipeline Variables

### 3.1 Edit Pipeline File

In your `azure-pipelines.yml`, update these variables with your actual values:

```yaml
variables:
  buildConfiguration: 'Release'
  azureSubscription: 'Azure-BasicDotnetApp-Connection'  # ✅ Must match your service connection name
  webAppName: 'basic-modern-dotnet-webapp-[YOUR-INITIALS]'  # ✅ Must match your Web App name
  resourceGroupName: 'rg-basic-dotnet-webapp'  # ✅ Must match your resource group
  artifactName: 'webapp-drop'
```

### 3.2 Commit Changes

```bash
git add azure-pipelines.yml
git commit -m "Update pipeline variables for Azure deployment"
git push origin main
```

---

## 🚀 Step 4: Create and Run Azure Pipeline

### 4.1 In Azure DevOps Portal

1. **Go to Pipelines**:
   - Azure DevOps → **Pipelines** → **Pipelines**

2. **Create New Pipeline**:
   - Click **New pipeline**
   - Select **Azure Repos Git** (if using Azure DevOps repo) or **GitHub** (if using GitHub)
   - Choose your repository: `basic-dotnet-app`
   - Select **Existing Azure Pipelines YAML file**
   - **Path**: `/azure-pipelines.yml`
   - Click **Continue**

3. **Review and Run**:
   - Review the pipeline YAML
   - Click **Save and run**
   - Add commit message: "Add Azure pipeline for deployment"
   - Click **Save and run** again

### 4.2 Monitor Pipeline Execution

**Build Stage** should complete in ~3-5 minutes:
- ✅ Install .NET 10 SDK
- ✅ Restore NuGet packages
- ✅ Build application
- ✅ Run tests (if any)
- ✅ Publish application
- ✅ Upload artifacts

**Deploy Stage** should complete in ~2-3 minutes:
- ✅ Download artifacts
- ✅ Deploy to Azure Web App
- ✅ Start Web App
- ✅ Show deployment success

---

## 🎯 Step 5: Verify Deployment

### 5.1 Check Pipeline Status

- Pipeline should show: ✅ **All stages passed**
- Build stage: ✅ **Succeeded**
- Deploy stage: ✅ **Succeeded**

### 5.2 Test Your Application

1. **Open Application URL**:
   ```
   https://basic-modern-dotnet-webapp-[YOUR-INITIALS].azurewebsites.net
   ```

2. **Expected Result**:
   - ✅ Application loads successfully
   - ✅ Shows your .NET web application
   - ✅ No errors in browser console

### 5.3 Verify in Azure Portal

1. **Go to App Service**:
   - Azure Portal → App Services → `basic-modern-dotnet-webapp-[YOUR-INITIALS]`

2. **Check Deployment Status**:
   - **Deployment Center** → Should show latest deployment
   - **Log Stream** → Should show application logs
   - **Metrics** → Should show incoming requests

---

## 🔧 Troubleshooting Common Issues

### ❌ Build Fails

**Error**: "SDK not found"
```bash
# Solution: Check .NET version in pipeline
- task: UseDotNet@2
  inputs:
    version: '10.x'  # or '8.x' if .NET 10 not available
```

### ❌ Service Connection Error

**Error**: "Could not find service connection"
- ✅ Verify service connection name matches exactly
- ✅ Check service connection is authorized for all pipelines
- ✅ Ensure Azure subscription has proper permissions

### ❌ Web App Not Found

**Error**: "Web app 'xxx' could not be found"
- ✅ Check web app name is correct and globally unique
- ✅ Verify web app exists in the specified resource group
- ✅ Ensure resource group name matches exactly

### ❌ Deployment Fails

**Error**: "Deployment failed"
- ✅ Check app service plan has sufficient resources
- ✅ Verify .NET runtime version compatibility
- ✅ Review deployment logs in Azure Portal

---

## 📊 Step 6: Set Up Monitoring (Optional)

### 6.1 Application Insights

```bash
# Enable Application Insights
az webapp config appsettings set \
  --name basic-modern-dotnet-webapp-[YOUR-INITIALS] \
  --resource-group rg-basic-dotnet-webapp \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY="your-key"
```

### 6.2 Environment Variables

In Azure Portal → App Service → Configuration:

| **Setting Name** | **Value** | **Description** |
|------------------|-----------|-----------------|
| `ASPNETCORE_ENVIRONMENT` | `Production` | Set environment |
| `WEBSITE_HTTPLOGGING_RETENTION_DAYS` | `7` | Log retention |
| `WEBSITE_LOAD_CERTIFICATES` | `*` | Load certificates |

---

## 🎉 Success Checklist

### ✅ Deployment Complete
- [ ] Pipeline runs successfully
- [ ] Build artifacts created
- [ ] Application deployed to Azure
- [ ] Web app accessible via URL
- [ ] No errors in deployment logs

### ✅ Production Ready
- [ ] HTTPS enabled (automatic in App Service)
- [ ] Custom domain configured (optional)
- [ ] Application Insights enabled (optional)
- [ ] Environment variables set
- [ ] Monitoring alerts configured (optional)

---

## 🔄 Continuous Deployment

### Auto-Deploy on Code Changes

Your pipeline is configured to automatically deploy when you push to:
- ✅ `main` branch
- ✅ `develop` branch

### Making Changes

1. **Update your code locally**
2. **Commit and push**:
   ```bash
   git add .
   git commit -m "Update application feature"
   git push origin main
   ```
3. **Pipeline automatically runs**
4. **Changes deployed to production**

---

## 🎯 Next Steps

### Enhancements to Consider

1. **🔀 Deployment Slots**: Blue/green deployments for zero downtime
2. **🔐 Key Vault**: Secure configuration management
3. **🌍 Multi-environment**: Dev/QA/Prod pipelines
4. **📊 Advanced Monitoring**: Performance insights and alerts
5. **🐳 Container Deployment**: Docker-based deployments

### Learning Resources

- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/)
- [Azure DevOps Pipelines Guide](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [.NET on Azure Best Practices](https://docs.microsoft.com/en-us/dotnet/azure/)

---

## 🏆 Congratulations!

You now have a **production-ready CI/CD pipeline** that automatically builds and deploys your .NET application to Azure App Service! 

**Your live application**: `https://basic-modern-dotnet-webapp-[YOUR-INITIALS].azurewebsites.net` 🌐