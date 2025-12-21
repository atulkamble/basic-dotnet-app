# Azure Pipeline Setup

This repository includes automated setup scripts to create Azure resources and configure your pipeline.

## Prerequisites

- Azure CLI installed and configured
- Azure DevOps account with a project
- Appropriate permissions in Azure subscription

## Option 1: Bash Script (Linux/macOS/WSL)

```bash
./setup-azure-pipeline.sh
```

## Option 2: PowerShell Script (Windows/PowerShell Core)

```powershell
./setup-azure-pipeline.ps1
```

## What the script does:

1. **Creates Azure Resources:**
   - Resource Group
   - App Service Plan (Basic tier)
   - Web App with .NET 8.0 runtime
   - Service Principal for Azure DevOps

2. **Updates Pipeline:**
   - Automatically replaces placeholder values in `azure-pipelines-deploy.yml`
   - Sets correct service connection name, web app name, and resource group

3. **Provides Setup Instructions:**
   - Service principal credentials for Azure DevOps service connection
   - Step-by-step instructions for completing the setup

## Manual Steps After Running Script:

1. Go to Azure DevOps: `https://dev.azure.com/{your-org}/{your-project}/_settings/adminservices`
2. Create new service connection using the provided credentials
3. Grant permission to all pipelines
4. Run your pipeline!

## Script Parameters:

Both scripts accept parameters for automation:

### Bash:
```bash
./setup-azure-pipeline.sh
```
(Interactive mode - will prompt for all values)

### PowerShell:
```powershell
./setup-azure-pipeline.ps1 -Subscription "Your Subscription" -ResourceGroup "rg-myapp" -WebAppName "myapp-unique" -Location "eastus" -OrgName "yourorg" -ProjectName "yourproject"
```

## Troubleshooting:

- Ensure Azure CLI is installed: `az --version`
- Login to Azure: `az login`
- Check permissions: You need Contributor access to the subscription
- Web app names must be globally unique across Azure

## Cost Information:

The script creates:
- **App Service Plan (B1)**: ~$13-54/month depending on region
- **Resource Group**: Free
- **Web App**: Included in App Service Plan cost

You can delete resources after testing:
```bash
az group delete --name your-resource-group-name
```