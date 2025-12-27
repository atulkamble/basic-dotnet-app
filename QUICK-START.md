# 🚀 Azure Pipeline Quick Start

## ✅ **SOLUTION**: Two-Pipeline Approach

I've created **two separate pipelines** to avoid Azure DevOps validation issues:

### 1. **Main Pipeline** (`azure-pipelines.yml`)
- **Purpose**: Build and testing
- **No deployment stages** = **No service connection errors**
- **Works immediately** ✅

### 2. **Deployment Pipeline** (`azure-pipelines-deploy.yml`)  
- **Purpose**: Build + Deploy to Azure
- **Use only after** service connection is set up
- **Manual trigger only**

## 🎯 **How to Use**

### Phase 1: Test Build (Right Now)
1. Create pipeline using `azure-pipelines.yml`
2. Run it - should work immediately! ✅
3. No service connection needed

### Phase 2: Add Deployment (Later)
1. Set up Azure service connection
2. Create second pipeline using `azure-pipelines-deploy.yml`
3. Use for actual deployments

## 📋 **Setup Steps**

### Step 1: Main Pipeline (Works Now)
```bash
# In Azure DevOps:
# - New Pipeline → Existing Azure Pipelines YAML file
# - Select: azure-pipelines.yml
# - Run pipeline (should succeed immediately)
```

### Step 2: Service Connection (When Ready)
```bash
# Run setup script
./setup-service-connection.sh

# Or manually in Azure DevOps:
# - Project Settings → Service connections
# - New service connection → Azure Resource Manager
# - Name: Azure-BasicDotnetApp-Connection
```

### Step 3: Deployment Pipeline (Optional)
```bash
# In Azure DevOps:
# - New Pipeline → Existing Azure Pipelines YAML file  
# - Select: azure-pipelines-deploy.yml
# - Configure parameters
# - Run for deployments
```

## 🎉 **Benefits**

- ✅ **No more YAML errors** - main pipeline has no complex conditions
- ✅ **Immediate success** - build works out of the box
- ✅ **Separation of concerns** - build vs deploy are separate
- ✅ **Easy testing** - can verify build without deployment setup

## 🔧 **Files Overview**

- `azure-pipelines.yml` → Build only (use first)
- `azure-pipelines-deploy.yml` → Build + Deploy (use after setup)
- `setup-service-connection.sh` → Automates Azure setup

---

**Try the main pipeline now - it should work immediately!** 🚀