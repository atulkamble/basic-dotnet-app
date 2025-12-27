#!/bin/bash

# Azure DevOps Service Connection Setup Script
# This script helps create the Azure service connection needed for the pipeline

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
SERVICE_CONNECTION_NAME="Azure-BasicDotnetApp-Connection"

echo "=============================================="
echo "Azure DevOps Service Connection Setup"
echo "=============================================="
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    print_error "Azure CLI is not installed. Please install it first:"
    echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
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
TENANT_ID=$(az account show --query "tenantId" --output tsv)

print_status "Current Azure Context:"
echo "  Subscription: $SUBSCRIPTION_NAME"
echo "  Subscription ID: $SUBSCRIPTION_ID"
echo "  Tenant ID: $TENANT_ID"
echo ""

# Create service principal
print_status "Creating service principal for Azure DevOps..."

SP_NAME="sp-basic-dotnet-webapp-$(date +%Y%m%d%H%M%S)"

# Create service principal and capture output
SP_OUTPUT=$(az ad sp create-for-rbac \
    --name "$SP_NAME" \
    --role "Contributor" \
    --scopes "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME" \
    --sdk-auth)

if [ $? -eq 0 ]; then
    print_success "Service principal created successfully!"
    
    # Parse the JSON output
    APP_ID=$(echo "$SP_OUTPUT" | jq -r '.clientId')
    CLIENT_SECRET=$(echo "$SP_OUTPUT" | jq -r '.clientSecret')
    
    echo ""
    print_success "Service Connection Details:"
    echo "======================================="
    echo "Service Connection Name: $SERVICE_CONNECTION_NAME"
    echo "App ID (Client ID): $APP_ID"
    echo "Client Secret: [HIDDEN - Check output below]"
    echo "Subscription ID: $SUBSCRIPTION_ID"
    echo "Subscription Name: $SUBSCRIPTION_NAME"
    echo "Tenant ID: $TENANT_ID"
    echo ""
    
    print_warning "⚠️  IMPORTANT: Save this client secret - it won't be shown again!"
    echo "Client Secret: $CLIENT_SECRET"
    echo ""
    
    print_status "📋 Next Steps:"
    echo "1. Go to Azure DevOps: https://dev.azure.com/"
    echo "2. Navigate to your project"
    echo "3. Go to Project Settings > Service connections"
    echo "4. Click 'New service connection'"
    echo "5. Select 'Azure Resource Manager' > Next"
    echo "6. Choose 'Service principal (manual)'"
    echo "7. Fill in the details shown above"
    echo "8. Test the connection"
    echo "9. Save as: $SERVICE_CONNECTION_NAME"
    echo ""
    
    print_status "🔧 Pipeline Configuration:"
    echo "Update your azure-pipelines.yml file:"
    echo "Replace 'YOUR_AZURE_SERVICE_CONNECTION_NAME' with '$SERVICE_CONNECTION_NAME'"
    echo ""
    
    # Save details to file
    cat > service-connection-details.txt << EOF
Azure DevOps Service Connection Details
Generated: $(date)
======================================

Service Connection Name: $SERVICE_CONNECTION_NAME
App ID (Client ID): $APP_ID
Client Secret: $CLIENT_SECRET
Subscription ID: $SUBSCRIPTION_ID
Subscription Name: $SUBSCRIPTION_NAME
Tenant ID: $TENANT_ID

Resource Group: $RESOURCE_GROUP_NAME
Service Principal Name: $SP_NAME

Setup Instructions:
1. Go to Azure DevOps Project Settings > Service connections
2. Create new Azure Resource Manager connection (manual)
3. Use the details above
4. Test and save the connection
5. Update azure-pipelines.yml with the connection name

IMPORTANT: Delete this file after setting up the service connection!
EOF
    
    print_success "Details saved to: service-connection-details.txt"
    print_warning "🔒 Delete this file after setup for security!"
    
else
    print_error "Failed to create service principal"
    exit 1
fi