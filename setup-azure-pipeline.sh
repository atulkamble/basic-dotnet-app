#!/bin/bash

# Azure DevOps Pipeline Setup Script
# This script creates Azure resources and updates the pipeline configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Azure Pipeline Setup Script ===${NC}"
echo ""

# Get user input
read -p "Enter your Azure subscription name or ID: " SUBSCRIPTION
read -p "Enter a name for your resource group (e.g., rg-basic-dotnet-app): " RESOURCE_GROUP
read -p "Enter a name for your web app (must be globally unique, e.g., basic-dotnet-app-$(date +%s)): " WEB_APP_NAME
read -p "Enter Azure region (e.g., eastus, westus2): " LOCATION
read -p "Enter your Azure DevOps organization name: " ORG_NAME
read -p "Enter your Azure DevOps project name: " PROJECT_NAME

echo ""
echo -e "${YELLOW}Configuration Summary:${NC}"
echo "Subscription: $SUBSCRIPTION"
echo "Resource Group: $RESOURCE_GROUP"
echo "Web App Name: $WEB_APP_NAME"
echo "Location: $LOCATION"
echo "DevOps Org: $ORG_NAME"
echo "DevOps Project: $PROJECT_NAME"
echo ""

read -p "Continue with this configuration? (y/n): " CONFIRM
if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo -e "${GREEN}Step 1: Logging into Azure${NC}"
az login

echo ""
echo -e "${GREEN}Step 2: Setting subscription${NC}"
az account set --subscription "$SUBSCRIPTION"

echo ""
echo -e "${GREEN}Step 3: Checking/Creating resource group${NC}"

# Check if resource group exists
if az group show --name "$RESOURCE_GROUP" &>/dev/null; then
    echo "Resource group '$RESOURCE_GROUP' already exists."
    EXISTING_LOCATION=$(az group show --name "$RESOURCE_GROUP" --query location -o tsv)
    echo "Existing location: $EXISTING_LOCATION"
    
    if [ "$EXISTING_LOCATION" != "$LOCATION" ]; then
        echo -e "${YELLOW}Warning: Resource group exists in '$EXISTING_LOCATION', but you specified '$LOCATION'${NC}"
        echo "Using existing location: $EXISTING_LOCATION"
        LOCATION="$EXISTING_LOCATION"
    fi
else
    echo "Creating new resource group in '$LOCATION'..."
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
fi

echo ""
echo -e "${GREEN}Step 4: Checking/Creating App Service Plan${NC}"
APP_SERVICE_PLAN="${WEB_APP_NAME}-plan"

# Check if App Service Plan already exists
if az appservice plan show --name "$APP_SERVICE_PLAN" --resource-group "$RESOURCE_GROUP" &>/dev/null; then
    echo "App Service Plan '$APP_SERVICE_PLAN' already exists. Skipping creation."
else
    echo "Creating App Service Plan '$APP_SERVICE_PLAN'..."
    az appservice plan create \
        --name "$APP_SERVICE_PLAN" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --sku B1 \
        --is-linux false
fi

echo ""
echo -e "${GREEN}Step 5: Checking/Creating Web App${NC}"

# Check if Web App already exists
if az webapp show --name "$WEB_APP_NAME" --resource-group "$RESOURCE_GROUP" &>/dev/null; then
    echo "Web App '$WEB_APP_NAME' already exists. Skipping creation."
else
    echo "Creating Web App '$WEB_APP_NAME'..."
    az webapp create \
        --name "$WEB_APP_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --plan "$APP_SERVICE_PLAN" \
        --runtime "DOTNET|8.0"
fi

echo ""
echo -e "${GREEN}Step 6: Getting subscription ID${NC}"
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo ""
echo -e "${GREEN}Step 7: Creating service principal for Azure DevOps${NC}"
SERVICE_PRINCIPAL_NAME="sp-${WEB_APP_NAME}-devops"

# Create service principal and capture output
SP_OUTPUT=$(az ad sp create-for-rbac \
    --name "$SERVICE_PRINCIPAL_NAME" \
    --role Contributor \
    --scopes "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
    --output json)

APP_ID=$(echo $SP_OUTPUT | jq -r '.appId')
PASSWORD=$(echo $SP_OUTPUT | jq -r '.password')
TENANT_ID=$(echo $SP_OUTPUT | jq -r '.tenant')

echo ""
echo -e "${GREEN}Step 8: Updating pipeline configuration${NC}"

# Generate service connection name
SERVICE_CONNECTION="azure-connection-${WEB_APP_NAME}"

# Update the pipeline file
sed -i.bak \
    -e "s/UPDATE-THIS-SERVICE-CONNECTION-NAME/${SERVICE_CONNECTION}/g" \
    -e "s/UPDATE-THIS-WEB-APP-NAME/${WEB_APP_NAME}/g" \
    -e "s/UPDATE-THIS-RESOURCE-GROUP-NAME/${RESOURCE_GROUP}/g" \
    azure-pipelines-deploy.yml

echo ""
echo -e "${GREEN}✅ Setup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}=== MANUAL STEPS REQUIRED ===${NC}"
echo ""
echo "1. Create Azure DevOps Service Connection:"
echo "   - Go to: https://dev.azure.com/${ORG_NAME}/${PROJECT_NAME}/_settings/adminservices"
echo "   - Click 'New service connection' → 'Azure Resource Manager'"
echo "   - Choose 'Service principal (manual)'"
echo "   - Fill in these details:"
echo ""
echo -e "${GREEN}   Service connection name:${NC} ${SERVICE_CONNECTION}"
echo -e "${GREEN}   Subscription ID:${NC} ${SUBSCRIPTION_ID}"
echo -e "${GREEN}   Subscription name:${NC} ${SUBSCRIPTION}"
echo -e "${GREEN}   Service principal ID:${NC} ${APP_ID}"
echo -e "${GREEN}   Service principal key:${NC} ${PASSWORD}"
echo -e "${GREEN}   Tenant ID:${NC} ${TENANT_ID}"
echo ""
echo "2. Grant access permission to all pipelines"
echo ""
echo "3. Your pipeline file has been updated with the correct values!"
echo ""
echo -e "${YELLOW}=== RESOURCES CREATED ===${NC}"
echo "• Resource Group: ${RESOURCE_GROUP}"
echo "• App Service Plan: ${APP_SERVICE_PLAN}"
echo "• Web App: ${WEB_APP_NAME}"
echo "• Service Principal: ${SERVICE_PRINCIPAL_NAME}"
echo ""
echo -e "${GREEN}Web App URL:${NC} https://${WEB_APP_NAME}.azurewebsites.net"
echo ""
echo -e "${YELLOW}Note:${NC} Service principal credentials have been saved above."
echo "Keep them secure and use them only for the Azure DevOps service connection."