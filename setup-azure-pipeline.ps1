# Azure DevOps Pipeline Setup Script (PowerShell)
# This script creates Azure resources and updates the pipeline configuration

param(
    [string]$Subscription,
    [string]$ResourceGroup,
    [string]$WebAppName,
    [string]$Location = "eastus",
    [string]$OrgName,
    [string]$ProjectName
)

# Colors for output
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"

Write-Host "=== Azure Pipeline Setup Script ===" -ForegroundColor $Green
Write-Host ""

# Get user input if not provided as parameters
if (-not $Subscription) {
    $Subscription = Read-Host "Enter your Azure subscription name or ID"
}
if (-not $ResourceGroup) {
    $ResourceGroup = Read-Host "Enter a name for your resource group (e.g., rg-basic-dotnet-app)"
}
if (-not $WebAppName) {
    $WebAppName = Read-Host "Enter a name for your web app (must be globally unique, e.g., basic-dotnet-app-$(Get-Date -Format 'yyyyMMddHHmm'))"
}
if (-not $Location) {
    $Location = Read-Host "Enter Azure region (e.g., eastus, westus2)"
}
if (-not $OrgName) {
    $OrgName = Read-Host "Enter your Azure DevOps organization name"
}
if (-not $ProjectName) {
    $ProjectName = Read-Host "Enter your Azure DevOps project name"
}

Write-Host ""
Write-Host "Configuration Summary:" -ForegroundColor $Yellow
Write-Host "Subscription: $Subscription"
Write-Host "Resource Group: $ResourceGroup"
Write-Host "Web App Name: $WebAppName"
Write-Host "Location: $Location"
Write-Host "DevOps Org: $OrgName"
Write-Host "DevOps Project: $ProjectName"
Write-Host ""

$Confirm = Read-Host "Continue with this configuration? (y/n)"
if ($Confirm -ne "y" -and $Confirm -ne "Y") {
    Write-Host "Setup cancelled."
    exit 0
}

try {
    Write-Host ""
    Write-Host "Step 1: Logging into Azure" -ForegroundColor $Green
    az login

    Write-Host ""
    Write-Host "Step 2: Setting subscription" -ForegroundColor $Green
    az account set --subscription $Subscription

    Write-Host ""
    Write-Host "Step 3: Checking/Creating resource group" -ForegroundColor $Green
    
    # Check if resource group exists
    $ExistingRG = az group show --name $ResourceGroup 2>$null | ConvertFrom-Json
    
    if ($ExistingRG) {
        Write-Host "Resource group '$ResourceGroup' already exists."
        $ExistingLocation = $ExistingRG.location
        Write-Host "Existing location: $ExistingLocation"
        
        if ($ExistingLocation -ne $Location) {
            Write-Host "Warning: Resource group exists in '$ExistingLocation', but you specified '$Location'" -ForegroundColor $Yellow
            Write-Host "Using existing location: $ExistingLocation"
            $Location = $ExistingLocation
        }
    } else {
        Write-Host "Creating new resource group in '$Location'..."
        az group create --name $ResourceGroup --location $Location
    }

    Write-Host ""
    Write-Host "Step 4: Creating App Service Plan" -ForegroundColor $Green
    $AppServicePlan = "${WebAppName}-plan"
    az appservice plan create `
        --name $AppServicePlan `
        --resource-group $ResourceGroup `
        --location $Location `
        --sku B1 `
        --is-linux false

    Write-Host ""
    Write-Host "Step 5: Creating Web App" -ForegroundColor $Green
    az webapp create `
        --name $WebAppName `
        --resource-group $ResourceGroup `
        --plan $AppServicePlan `
        --runtime "DOTNET|8.0"

    Write-Host ""
    Write-Host "Step 6: Getting subscription ID" -ForegroundColor $Green
    $SubscriptionId = az account show --query id -o tsv

    Write-Host ""
    Write-Host "Step 7: Creating service principal for Azure DevOps" -ForegroundColor $Green
    $ServicePrincipalName = "sp-${WebAppName}-devops"

    # Create service principal and capture output
    $SpOutput = az ad sp create-for-rbac `
        --name $ServicePrincipalName `
        --role Contributor `
        --scopes "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup" `
        --output json | ConvertFrom-Json

    $AppId = $SpOutput.appId
    $Password = $SpOutput.password
    $TenantId = $SpOutput.tenant

    Write-Host ""
    Write-Host "Step 8: Updating pipeline configuration" -ForegroundColor $Green

    # Generate service connection name
    $ServiceConnection = "azure-connection-${WebAppName}"

    # Update the pipeline file
    $PipelineContent = Get-Content "azure-pipelines-deploy.yml" -Raw
    $PipelineContent = $PipelineContent -replace "UPDATE-THIS-SERVICE-CONNECTION-NAME", $ServiceConnection
    $PipelineContent = $PipelineContent -replace "UPDATE-THIS-WEB-APP-NAME", $WebAppName
    $PipelineContent = $PipelineContent -replace "UPDATE-THIS-RESOURCE-GROUP-NAME", $ResourceGroup
    Set-Content "azure-pipelines-deploy.yml" -Value $PipelineContent

    Write-Host ""
    Write-Host "✅ Setup completed successfully!" -ForegroundColor $Green
    Write-Host ""
    Write-Host "=== MANUAL STEPS REQUIRED ===" -ForegroundColor $Yellow
    Write-Host ""
    Write-Host "1. Create Azure DevOps Service Connection:"
    Write-Host "   - Go to: https://dev.azure.com/${OrgName}/${ProjectName}/_settings/adminservices"
    Write-Host "   - Click 'New service connection' → 'Azure Resource Manager'"
    Write-Host "   - Choose 'Service principal (manual)'"
    Write-Host "   - Fill in these details:"
    Write-Host ""
    Write-Host "   Service connection name: " -NoNewline
    Write-Host $ServiceConnection -ForegroundColor $Green
    Write-Host "   Subscription ID: " -NoNewline
    Write-Host $SubscriptionId -ForegroundColor $Green
    Write-Host "   Subscription name: " -NoNewline
    Write-Host $Subscription -ForegroundColor $Green
    Write-Host "   Service principal ID: " -NoNewline
    Write-Host $AppId -ForegroundColor $Green
    Write-Host "   Service principal key: " -NoNewline
    Write-Host $Password -ForegroundColor $Green
    Write-Host "   Tenant ID: " -NoNewline
    Write-Host $TenantId -ForegroundColor $Green
    Write-Host ""
    Write-Host "2. Grant access permission to all pipelines"
    Write-Host ""
    Write-Host "3. Your pipeline file has been updated with the correct values!"
    Write-Host ""
    Write-Host "=== RESOURCES CREATED ===" -ForegroundColor $Yellow
    Write-Host "• Resource Group: $ResourceGroup"
    Write-Host "• App Service Plan: $AppServicePlan"
    Write-Host "• Web App: $WebAppName"
    Write-Host "• Service Principal: $ServicePrincipalName"
    Write-Host ""
    Write-Host "Web App URL: " -NoNewline
    Write-Host "https://${WebAppName}.azurewebsites.net" -ForegroundColor $Green
    Write-Host ""
    Write-Host "Note: " -ForegroundColor $Yellow -NoNewline
    Write-Host "Service principal credentials have been saved above."
    Write-Host "Keep them secure and use them only for the Azure DevOps service connection."

} catch {
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor $Red
    Write-Host "Please check your Azure CLI installation and permissions." -ForegroundColor $Red
    exit 1
}