#!/bin/bash

# Direct Azure Deployment Script
# This script deploys the .NET web app directly to Azure App Service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Configuration
RESOURCE_GROUP_NAME="rg-basic-dotnet-webapp"
WEBAPP_NAME="basic-modern-dotnet-webapp"
APP_SERVICE_PLAN_NAME="asp-basic-dotnet-webapp"
LOCATION="eastus"
RUNTIME="DOTNET:8.0"

echo "=============================================="
echo "🚀 Azure Web App Direct Deployment"
echo "=============================================="
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    print_error "Azure CLI is not installed. Please install it first."
    exit 1
fi

# Check if user is logged in
if ! az account show &> /dev/null; then
    print_error "You are not logged in to Azure. Please run 'az login' first."
    exit 1
fi

# Get current subscription info
SUBSCRIPTION_ID=$(az account show --query "id" --output tsv)
SUBSCRIPTION_NAME=$(az account show --query "name" --output tsv)

print_status "Current Azure Context:"
echo "  Subscription: $SUBSCRIPTION_NAME"
echo "  Subscription ID: $SUBSCRIPTION_ID"
echo ""

# Check if resource group exists
print_status "Checking resource group: $RESOURCE_GROUP_NAME"
if az group show --name "$RESOURCE_GROUP_NAME" &> /dev/null; then
    print_success "Resource group exists"
else
    print_status "Creating resource group: $RESOURCE_GROUP_NAME"
    az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION"
    print_success "Resource group created"
fi

echo ""

# Create App Service Plan
print_status "Creating App Service Plan: $APP_SERVICE_PLAN_NAME"
if az appservice plan show --name "$APP_SERVICE_PLAN_NAME" --resource-group "$RESOURCE_GROUP_NAME" &> /dev/null; then
    print_success "App Service Plan already exists"
else
    print_status "Creating Free tier App Service Plan..."
    az appservice plan create \
        --name "$APP_SERVICE_PLAN_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --sku F1
    print_success "App Service Plan created (Free tier)"
fi

echo ""

# Create Web App
print_status "Creating Web App: $WEBAPP_NAME"
if az webapp show --name "$WEBAPP_NAME" --resource-group "$RESOURCE_GROUP_NAME" &> /dev/null; then
    print_success "Web App already exists"
else
    az webapp create \
        --name "$WEBAPP_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --plan "$APP_SERVICE_PLAN_NAME" \
        --runtime "$RUNTIME"
    print_success "Web App created"
fi

echo ""

# Build and publish the application
print_status "Building .NET application..."
if ! command -v dotnet &> /dev/null; then
    print_error ".NET SDK is not installed. Please install .NET 8.0 SDK."
    exit 1
fi

dotnet restore
dotnet build --configuration Release
dotnet publish --configuration Release --output ./publish

print_success "Application built successfully"

echo ""

# Create deployment package
print_status "Creating deployment package..."
cd publish
zip -r ../webapp-package.zip . -x "*.pdb"
cd ..

print_success "Deployment package created: webapp-package.zip"

echo ""

# Deploy to Azure Web App
print_status "Deploying to Azure Web App..."
az webapp deployment source config-zip \
    --name "$WEBAPP_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --src webapp-package.zip

print_success "Deployment completed!"

echo ""

# Get the web app URL
WEBAPP_URL="https://${WEBAPP_NAME}.azurewebsites.net"

print_success "🎉 Deployment Successful!"
echo "======================================="
echo "🌐 Web App URL: $WEBAPP_URL"
echo "📊 Resource Group: $RESOURCE_GROUP_NAME"
echo "⚙️  App Service Plan: $APP_SERVICE_PLAN_NAME"
echo ""

print_status "🔍 Checking web app status..."
sleep 10  # Give the app time to start

# Test the web app
if curl -s -o /dev/null -w "%{http_code}" "$WEBAPP_URL" | grep -q "200"; then
    print_success "✅ Web app is running successfully!"
    print_status "🌐 Visit your app: $WEBAPP_URL"
else
    print_warning "⚠️  Web app might still be starting up..."
    print_status "🔄 Check the URL in a few minutes: $WEBAPP_URL"
fi

echo ""
print_status "📋 Next Steps:"
echo "1. Visit your web app: $WEBAPP_URL"
echo "2. Set up Azure DevOps pipeline for future deployments"
echo "3. Configure custom domain (optional)"
echo ""

# Cleanup deployment files
rm -f webapp-package.zip
rm -rf publish

print_success "🎯 Deployment completed successfully!"