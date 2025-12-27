#!/bin/bash

# YAML Validation Script for Azure Pipelines
# This script validates the azure-pipelines.yml file for syntax errors

set -e

echo "🔍 Validating Azure Pipeline YAML..."
echo "=================================="

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required for YAML validation"
    exit 1
fi

# Check if YAML file exists
if [ ! -f "azure-pipelines.yml" ]; then
    echo "❌ azure-pipelines.yml file not found"
    exit 1
fi

# Validate YAML syntax
echo "📝 Checking YAML syntax..."
if python3 -c "import yaml; yaml.safe_load(open('azure-pipelines.yml', 'r'))" 2>/dev/null; then
    echo "✅ YAML syntax is valid"
else
    echo "❌ YAML syntax error detected!"
    echo ""
    echo "Common issues to check:"
    echo "- Indentation (use spaces, not tabs)"
    echo "- Missing colons after keys"
    echo "- Incorrect list formatting"
    echo "- Unescaped special characters"
    exit 1
fi

# Check for common Azure DevOps YAML issues
echo ""
echo "🔍 Checking Azure DevOps specific patterns..."

# Check for required sections
if grep -q "^trigger:" azure-pipelines.yml; then
    echo "✅ Trigger section found"
else
    echo "⚠️  No trigger section found"
fi

if grep -q "^stages:" azure-pipelines.yml; then
    echo "✅ Stages section found"
else
    echo "⚠️  No stages section found"
fi

# Check for parameters
if grep -q "^parameters:" azure-pipelines.yml; then
    echo "✅ Parameters section found"
    
    # Count parameters
    PARAM_COUNT=$(grep -c "^- name:" azure-pipelines.yml)
    echo "   Found $PARAM_COUNT parameters"
fi

# Check for conditional deployment
if grep -q '\${{ if eq(parameters\.enableDeployment, true) }}:' azure-pipelines.yml; then
    echo "✅ Conditional deployment template found"
else
    echo "⚠️  No conditional deployment template found"
fi

echo ""
echo "🎉 YAML validation completed!"
echo ""
echo "💡 Tips:"
echo "- Test the pipeline in Azure DevOps to catch runtime issues"
echo "- Use 'Validate' button in Azure DevOps pipeline editor"
echo "- Check service connection names match exactly"