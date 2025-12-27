#!/bin/bash

# Azure Infrastructure Deployment Script for Basic Modern Dotnet WebApp
# This script deploys the ARM template to create Azure App Service resources

set -e  # Exit on any error

# Configuration
RESOURCE_GROUP_NAME="rg-basic-dotnet-webapp"
LOCATION="eastus2"
TEMPLATE_FILE="azure-infrastructure.json"
WEBAPP_NAME="basic-modern-dotnet-webapp"
APP_SERVICE_PLAN_NAME="asp-basic-dotnet-webapp"
ENVIRONMENT="Production"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Azure CLI is installed
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install it first:"
        print_error "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    fi
    
    if ! az account show &> /dev/null; then
        print_error "You are not logged in to Azure. Please run 'az login' first."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to create resource group
create_resource_group() {
    print_status "Creating resource group: $RESOURCE_GROUP_NAME"
    
    if az group show --name "$RESOURCE_GROUP_NAME" &> /dev/null; then
        print_warning "Resource group $RESOURCE_GROUP_NAME already exists"
    else
        az group create \
            --name "$RESOURCE_GROUP_NAME" \
            --location "$LOCATION" \
            --output table
        print_success "Resource group created successfully"
    fi
}

# Function to deploy ARM template
deploy_infrastructure() {
    print_status "Deploying infrastructure using ARM template..."
    
    local deployment_name="webapp-deployment-$(date +%Y%m%d-%H%M%S)"
    
    az deployment group create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --template-file "$TEMPLATE_FILE" \
        --parameters \
            webAppName="$WEBAPP_NAME" \
            appServicePlanName="$APP_SERVICE_PLAN_NAME" \
            location="$LOCATION" \
            environment="$ENVIRONMENT" \
        --name "$deployment_name" \
        --output table
    
    print_success "Infrastructure deployed successfully"
}

# Function to get deployment outputs
get_deployment_info() {
    print_status "Getting deployment information..."
    
    local latest_deployment=$(az deployment group list \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --query "[0].name" \
        --output tsv)
    
    if [ -n "$latest_deployment" ]; then
        echo ""
        print_success "Deployment Information:"
        echo "========================"
        
        local web_app_name=$(az deployment group show \
            --resource-group "$RESOURCE_GROUP_NAME" \
            --name "$latest_deployment" \
            --query "properties.outputs.webAppName.value" \
            --output tsv)
        
        local web_app_url=$(az deployment group show \
            --resource-group "$RESOURCE_GROUP_NAME" \
            --name "$latest_deployment" \
            --query "properties.outputs.webAppUrl.value" \
            --output tsv)
        
        echo "Web App Name: $web_app_name"
        echo "Web App URL: $web_app_url"
        echo "Resource Group: $RESOURCE_GROUP_NAME"
        echo ""
        print_status "You can now configure your Azure DevOps pipeline with these details."
    fi
}

# Function to create Azure DevOps service connection (informational)
show_service_connection_info() {
    print_status "Azure DevOps Service Connection Setup:"
    echo "========================================"
    echo "1. Go to your Azure DevOps project"
    echo "2. Navigate to Project Settings > Service connections"
    echo "3. Create a new service connection of type 'Azure Resource Manager'"
    echo "4. Choose 'Service principal (automatic)'"
    echo "5. Select your subscription and resource group: $RESOURCE_GROUP_NAME"
    echo "6. Name it: 'Azure-Service-Connection'"
    echo "7. Update the pipeline variables in azure-pipelines.yml with your values"
    echo ""
}

# Function to validate template
validate_template() {
    print_status "Validating ARM template..."
    
    az deployment group validate \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --template-file "$TEMPLATE_FILE" \
        --parameters \
            webAppName="$WEBAPP_NAME" \
            appServicePlanName="$APP_SERVICE_PLAN_NAME" \
            location="$LOCATION" \
            environment="$ENVIRONMENT" \
        --output table
    
    print_success "Template validation passed"
}

# Main execution
main() {
    echo "=============================================="
    echo "Azure Infrastructure Deployment Script"
    echo "Basic Modern Dotnet WebApp"
    echo "=============================================="
    echo ""
    
    # Parse command line arguments
    case "${1:-deploy}" in
        "validate")
            check_prerequisites
            create_resource_group
            validate_template
            ;;
        "deploy")
            check_prerequisites
            create_resource_group
            validate_template
            deploy_infrastructure
            get_deployment_info
            show_service_connection_info
            ;;
        "clean")
            print_warning "This will delete the entire resource group: $RESOURCE_GROUP_NAME"
            read -p "Are you sure? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                print_status "Deleting resource group..."
                az group delete --name "$RESOURCE_GROUP_NAME" --yes --no-wait
                print_success "Resource group deletion initiated"
            else
                print_status "Cancelled"
            fi
            ;;
        *)
            echo "Usage: $0 {validate|deploy|clean}"
            echo ""
            echo "Commands:"
            echo "  validate - Validate the ARM template"
            echo "  deploy   - Deploy the infrastructure (default)"
            echo "  clean    - Delete the resource group and all resources"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"