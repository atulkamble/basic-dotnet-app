# Azure Deployment Guide

This guide will help you deploy the Basic Modern Dotnet WebApp to Azure App Service using Azure DevOps Pipelines.

## 🚀 Quick Start

### Prerequisites

1. **Azure CLI** installed and logged in
   ```bash
   # Install Azure CLI (macOS)
   brew install azure-cli
   
   # Login to Azure
   az login
   ```

2. **Azure DevOps** project with repository access

3. **Azure Subscription** with sufficient permissions

### 📋 Step 1: Deploy Azure Infrastructure

Run the deployment script to create the Azure App Service resources:

```bash
# Validate the ARM template
./deploy-azure-infrastructure.sh validate

# Deploy the infrastructure
./deploy-azure-infrastructure.sh deploy

# Clean up (delete all resources)
./deploy-azure-infrastructure.sh clean
```

The script will create:
- **Resource Group**: `rg-basic-dotnet-webapp`
- **App Service Plan**: `asp-basic-dotnet-webapp` (Basic B1 tier)
- **Web App**: `basic-modern-dotnet-webapp`

### 📋 Step 2: Configure Azure DevOps Pipeline

1. **Create Service Connection**:
   - Go to Azure DevOps → Project Settings → Service connections
   - Create new "Azure Resource Manager" connection
   - Use "Service principal (automatic)"
   - Select your subscription and resource group
   - Name it: `Azure-Service-Connection`

2. **Update Pipeline Variables**:
   Edit `azure-pipelines.yml` and update these variables if needed:
   ```yaml
   variables:
     azureSubscription: 'Azure-Service-Connection'  # Your service connection name
     webAppName: 'basic-modern-dotnet-webapp'       # Your web app name
     resourceGroupName: 'rg-basic-dotnet-webapp'    # Your resource group
   ```

3. **Create Pipeline**:
   - Go to Azure DevOps → Pipelines → New pipeline
   - Select your repository
   - Choose "Existing Azure Pipelines YAML file"
   - Select `/azure-pipelines.yml`

### 📋 Step 3: Configure Environments (Optional)

Create environments in Azure DevOps for deployment approvals:

1. Go to **Pipelines → Environments**
2. Create environments:
   - `Development` (for develop branch deployments)
   - `Production` (for main branch deployments)
3. Add approval gates if needed

## 🏗️ Pipeline Features

### Multi-Stage Pipeline
- **Build Stage**: Restore, build, test, and publish
- **Deploy Development**: Auto-deploy from `develop` branch
- **Deploy Production**: Auto-deploy from `main` branch
- **Health Check**: Verify deployment success

### Build Process
1. Install .NET 8.0 SDK
2. Restore NuGet packages
3. Build application
4. Run unit tests (if available)
5. Publish application artifacts
6. Upload build artifacts

### Deployment Process
1. Download build artifacts
2. Deploy to Azure App Service
3. Configure environment variables
4. Health check verification

## 🔧 Configuration

### Environment Variables
The pipeline automatically configures these app settings:

**Development**:
```yaml
ASPNETCORE_ENVIRONMENT: Development
ASPNETCORE_HTTP_PORTS: 80
```

**Production**:
```yaml
ASPNETCORE_ENVIRONMENT: Production
ASPNETCORE_HTTP_PORTS: 80
ASPNETCORE_HTTPS_PORT: 443
```

### App Service Configuration
- **.NET Version**: 8.0
- **Platform**: Windows
- **SKU**: Basic B1 (can be changed in ARM template)
- **Always On**: Enabled
- **HTTPS Only**: Enabled

## 📁 Project Structure

```
├── azure-pipelines.yml              # Main pipeline definition
├── azure-infrastructure.json        # ARM template for Azure resources
├── deploy-azure-infrastructure.sh   # Infrastructure deployment script
├── basic-dotnet-webapp.csproj      # .NET project file
├── Program.cs                       # Application entry point
├── Pages/                           # Razor Pages
├── wwwroot/                        # Static assets
└── Dockerfile                      # Docker configuration
```

## 🌐 Access Your App

After successful deployment, your app will be available at:
- **Production**: `https://basic-modern-dotnet-webapp.azurewebsites.net`
- **Development**: `https://basic-modern-dotnet-webapp-dev.azurewebsites.net`

## 🔍 Monitoring and Troubleshooting

### View Deployment Logs
1. Go to Azure DevOps → Pipelines → Runs
2. Click on a pipeline run to see detailed logs
3. Check each stage for errors or warnings

### View App Service Logs
1. Go to Azure Portal → App Services → Your Web App
2. Navigate to Monitoring → Log stream
3. Or use Azure CLI:
   ```bash
   az webapp log tail --resource-group rg-basic-dotnet-webapp --name basic-modern-dotnet-webapp
   ```

### Common Issues

**Build Failures**:
- Check .NET version compatibility
- Verify NuGet package dependencies
- Review build logs for specific errors

**Deployment Failures**:
- Verify Azure service connection
- Check resource group and web app names
- Ensure sufficient Azure permissions

**Runtime Issues**:
- Check Application Insights for errors
- Review app service logs
- Verify environment configuration

## 🚦 Branch Strategy

The pipeline supports GitFlow branching:

- **`main` branch**: Deploys to Production environment
- **`develop` branch**: Deploys to Development environment
- **Feature branches**: Build only, no deployment

## 📊 Cost Estimation

**Basic B1 App Service Plan**:
- ~$13-15/month (varies by region)
- 1.75 GB RAM, 10 GB storage
- Custom domains and SSL certificates

**Optimization Tips**:
- Use Free tier (F1) for development
- Consider App Service Environment for production workloads
- Monitor usage and scale as needed

## 🔒 Security Best Practices

1. **Use managed identities** where possible
2. **Enable HTTPS only** (already configured)
3. **Configure IP restrictions** if needed
4. **Use Key Vault** for sensitive configuration
5. **Regular security updates** via pipeline automation

## 📚 Additional Resources

- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/)
- [Azure DevOps Pipeline Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [.NET on Azure Documentation](https://docs.microsoft.com/en-us/azure/app-service/quickstart-dotnetcore)

---

## 🎯 Next Steps

1. Run the infrastructure deployment script
2. Set up the Azure DevOps pipeline
3. Push code to trigger your first deployment
4. Monitor the deployment and verify functionality
5. Set up monitoring and alerts as needed

Happy deploying! 🚀