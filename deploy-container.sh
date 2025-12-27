#!/bin/bash

# Azure Container Instance Deployment Script
# This script deploys the .NET web app using Azure Container Instances

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
CONTAINER_NAME="basic-dotnet-webapp-container"
ACR_NAME="acrbasicdotnetwebapp$(date +%Y%m%d)"
IMAGE_NAME="basic-dotnet-webapp"
LOCATION="eastus"
DNS_NAME="basic-dotnet-webapp-$(date +%m%d)"

echo "=============================================="
echo "🐳 Azure Container Instance Deployment"
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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
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

# Create Azure Container Registry
print_status "Creating Azure Container Registry: $ACR_NAME"
if az acr show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP_NAME" &> /dev/null; then
    print_success "ACR already exists"
else
    az acr create \
        --name "$ACR_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --sku Basic \
        --admin-enabled true
    print_success "ACR created successfully"
fi

# Get ACR credentials
print_status "Getting ACR credentials..."
ACR_SERVER=$(az acr show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP_NAME" --query "loginServer" --output tsv)
ACR_USERNAME=$(az acr credential show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP_NAME" --query "username" --output tsv)
ACR_PASSWORD=$(az acr credential show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP_NAME" --query "passwords[0].value" --output tsv)

echo ""

# Build and push Docker image
print_status "Building Docker image..."
docker build -t "$IMAGE_NAME:latest" .

print_status "Tagging image for ACR..."
docker tag "$IMAGE_NAME:latest" "$ACR_SERVER/$IMAGE_NAME:latest"

print_status "Logging in to ACR..."
echo "$ACR_PASSWORD" | docker login "$ACR_SERVER" --username "$ACR_USERNAME" --password-stdin

print_status "Pushing image to ACR..."
docker push "$ACR_SERVER/$IMAGE_NAME:latest"

print_success "Docker image pushed successfully"

echo ""

# Deploy to Azure Container Instances
print_status "Deploying to Azure Container Instances..."
az container create \
    --name "$CONTAINER_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION" \
    --image "$ACR_SERVER/$IMAGE_NAME:latest" \
    --registry-login-server "$ACR_SERVER" \
    --registry-username "$ACR_USERNAME" \
    --registry-password "$ACR_PASSWORD" \
    --dns-name-label "$DNS_NAME" \
    --ports 5000 \
    --protocol TCP \
    --os-type Linux \
    --cpu 1 \
    --memory 1 \
    --environment-variables ASPNETCORE_URLS=http://+:5000

print_success "Container deployed successfully!"

echo ""

# Get the container URL
CONTAINER_URL="http://${DNS_NAME}.${LOCATION}.azurecontainer.io:5000"

print_success "🎉 Deployment Successful!"
echo "======================================="
echo "🌐 Container URL: $CONTAINER_URL"
echo "🐳 Container Name: $CONTAINER_NAME"
echo "📊 Resource Group: $RESOURCE_GROUP_NAME"
echo "🗃️  ACR: $ACR_SERVER"
echo ""

print_status "🔍 Checking container status..."
sleep 15  # Give the container time to start

# Check container status
CONTAINER_STATE=$(az container show --name "$CONTAINER_NAME" --resource-group "$RESOURCE_GROUP_NAME" --query "instanceView.state" --output tsv)
print_status "Container State: $CONTAINER_STATE"

if [ "$CONTAINER_STATE" = "Running" ]; then
    print_success "✅ Container is running successfully!"
    print_status "🌐 Visit your app: $CONTAINER_URL"
    
    # Test the endpoint
    if curl -s -o /dev/null -w "%{http_code}" "$CONTAINER_URL" | grep -q "200"; then
        print_success "✅ Web app is responding!"
    else
        print_warning "⚠️  App might still be starting up..."
    fi
else
    print_warning "⚠️  Container is in state: $CONTAINER_STATE"
    print_status "Check logs with: az container logs --name $CONTAINER_NAME --resource-group $RESOURCE_GROUP_NAME"
fi

echo ""
print_status "📋 Next Steps:"
echo "1. Visit your app: $CONTAINER_URL"
echo "2. Check logs: az container logs --name $CONTAINER_NAME --resource-group $RESOURCE_GROUP_NAME"
echo "3. Scale up if needed: az container update --name $CONTAINER_NAME --resource-group $RESOURCE_GROUP_NAME --cpu 2 --memory 2"
echo ""

print_success "🎯 Container deployment completed!"
print_status "💰 Cost: ~$0.01/hour for this configuration"