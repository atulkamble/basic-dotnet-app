# 🚀 Deploy ASP.NET Core App to Azure Web App using Docker & ACR

**Tip:**
This guide uses **updated code, Dockerfile, and .NET port configuration (port 80)**.
**Reference Repository:**
👉 [https://github.com/atulkamble/basic-dotnet-app](https://github.com/atulkamble/basic-dotnet-app)

---

## 🧩 Architecture Overview

* ASP.NET Core Web App
* Docker Container
* Azure Container Registry (ACR)
* Azure App Service (Web App for Containers)
* Azure VM (for Docker build & push)

---

## 🔐 0. Login to Azure VM

```bash
cd Downloads
chmod 400 vm_key.pem
ssh -i vm_key.pem azureuser@20.244.2.138
```

---

## 🐳 0.1 Install Docker on Azure VM

```bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version
```

---

## 🔑 0.2 Install Azure CLI & Login

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version
sudo az login
```

Login to Azure Container Registry:

```bash
sudo az acr login --name atulkamble
```

---

## 📥 1. Clone ASP.NET Core Project

```bash
git clone https://github.com/atulkamble/basic-dotnet-app.git
cd basic-dotnet-app
```

---

## ▶️ 2. Run Application Locally (Optional Validation)

```bash
dotnet build
dotnet run
```

Access locally:

```
http://localhost:5000
```

---

## 🧱 3. Create Azure Container Registry (ACR)

> If not already created, create an ACR from Azure Portal or CLI.

**Example:**

* Registry Name: `atulkamble`
* SKU: Basic
* Login Server: `atulkamble.azurecr.io`

---

## 🐳 4. Build Docker Image

```bash
sudo docker build -t atulkamble.azurecr.io/cloudnautic/basic-dotnet-app .
```

Verify image:

```bash
docker images
```

---

## 📤 5. Push Docker Image to ACR

```bash
sudo docker push atulkamble.azurecr.io/cloudnautic/basic-dotnet-app
```

---

## 🌐 6. Create Azure Web App (Container)

From **Azure Portal**:

1. Create **Web App**
2. App Name: `atulkamble859708`
3. Publish: **Docker Container**
4. OS: **Linux**
5. App Service Plan: **B1**
6. Image Source: **Azure Container Registry**
7. Image:

   ```
   atulkamble.azurecr.io/cloudnautic/basic-dotnet-app
   ```

---

## ⚙️ 7. Configure Container Port (IMPORTANT)

Go to:

```
Web App → Configuration → Application settings
```

Add setting:

| Name          | Value |
| ------------- | ----- |
| WEBSITES_PORT | 80    |

Save and Restart the Web App.

---

## 🔗 8. Access Deployed Application

Example URL:

```
https://mywebappatulkamble98600-h7cxhccgayejgff8.canadacentral-01.azurewebsites.net/
```

You should see the ASP.NET Core UI running successfully 🎉

---

## 🧹 9. Cleanup (Optional)

To avoid unnecessary cost:

```bash
az group delete --name <resource-group-name> --yes --no-wait
```

Or delete the **Resource Group** directly from Azure Portal.

---

## ✅ Key Notes

* Application listens on **port 80** inside the container
* `WEBSITES_PORT=80` is mandatory for Azure App Service
* Docker image is pulled directly from ACR
* B1 plan is sufficient for demo/labs

---

## 📌 Repository Reference

🔗 [https://github.com/atulkamble/basic-dotnet-app](https://github.com/atulkamble/basic-dotnet-app)

---




# 🚀 Basic .NET Web Application – Complete Setup & Deployment Guide

<div align="center">

**Basic .NET WebApp**  
*Built with ❤️ using ASP.NET Core*

</div>

## 📌 Project Overview

This project demonstrates how to:

✅ Install .NET SDK  
✅ Create a basic ASP.NET Core Web Application  
✅ Run and test the application locally  
✅ Open and manage the project in VS Code  
✅ Containerize the app using Docker  
✅ Deploy the application to AWS Elastic Beanstalk  
✅ Push the source code to GitHub  

## 🧰 Prerequisites

Ensure the following tools are installed:

✅ .NET SDK  
✅ Chocolatey (Windows)  
✅ Visual Studio Code  
✅ Git  
✅ AWS CLI  
✅ Elastic Beanstalk CLI (eb)  
✅ Docker (for containerization)  

## 🔹 Step 1: Install .NET SDK

**Download from the official site:**  
👉 https://dotnet.microsoft.com/en-us/download

### 📦 Install using Chocolatey (Windows)
```bash
choco install dotnet
```

### 🔍 Verify Installation
```bash
dotnet --version
```

## 🔹 Step 2: Create a Basic .NET Web App

### 🆕 Create Project Using Template
```bash
dotnet new webapp -n basic-dotnet-webapp
```

### 📂 Navigate to Project Directory
```bash
cd basic-dotnet-webapp
```

### 🔨 Build the Application
```bash
dotnet build
```

### ▶️ Run the Application
```bash
dotnet run
```

**📌 Application runs by default on:**  
http://localhost:5000 or https://localhost:5001

## 🎨 Create a Basic .NET Web App with UI

ASP.NET WebApp template includes Razor Pages UI by default.

```bash
dotnet new webapp -n BasicDotNetApp
dotnet build
dotnet run
```

You can customize UI files from:

```
Pages/
 ├── Index.cshtml
 ├── Privacy.cshtml
 └── Shared/
```

## 🔹 Step 3: VS Code Setup

### 🔌 Recommended VS Code Extensions

Install the following plugins:

- GitHub Copilot
- GitHub Repositories  
- AWS Toolkit
- Python
- Pip

### 📂 Open Project in VS Code
```bash
code .
```

## 🔹 Step 4: Create Project Manually (Optional)
```bash
mkdir project
cd project
dotnet new webapp
dotnet build
dotnet run
```

## 🐳 Step 5: Create Dockerfile

Create a Dockerfile in the project root:

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY bin/Release/net10.0/publish/ .
ENTRYPOINT ["dotnet", "BasicDotNetApp.dll"]
```

### 📦 Publish App for Docker
```bash
dotnet publish -c Release
```

## ☁️ Step 6: Deploy to AWS Elastic Beanstalk

### 🔧 Initialize EB Environment
```bash
eb init
```

- Select region
- Choose Docker or .NET platform
- Configure IAM if prompted

### 🚀 Create Production Environment
```bash
eb create production
```

### 🌐 Open Application in Browser
```bash
eb open
```

### ❌ Terminate Environment (Cleanup)
```bash
eb terminate production
```

## 🔹 Step 7: Push Code to GitHub

```bash
git init
git add .
git commit -m "Initial commit - Basic .NET WebApp"
git branch -M main
git remote add origin https://github.com/<username>/<repo-name>.git
git push -u origin main
```

## 📁 Project Structure

```
basic-dotnet-webapp/
├── Pages/
├── wwwroot/
├── Program.cs
├── appsettings.json
├── Dockerfile
├── README.md
└── basic-dotnet-webapp.csproj
```

## ✅ Key Takeaways

✔ ASP.NET Core WebApp created using templates  
✔ UI enabled using Razor Pages  
✔ Local build & run verified  
✔ Dockerized application  
✔ Deployed to AWS Elastic Beanstalk  
✔ Version-controlled with GitHub

```bash
dotnet new webapp -n basic-dotnet-webapp
```

📁 This command creates a new project folder named **basic-dotnet-webapp**.

---

## 📂 Step 4: Navigate to Project Directory

```bash
cd basic-dotnet-webapp
```

---

## 🛠️ Step 5: Build the Application

Compile the project to ensure everything is configured correctly:

```bash
dotnet build
```

✔️ This step validates dependencies and project structure.

---

## ▶️ Step 6: Run the Application

Start the development server:

```bash
dotnet run
```

Once the app is running, open your browser and visit:

```
https://localhost:5001
or
http://localhost:5000
```

---

## 📁 Project Structure (Overview)

```text
basic-dotnet-webapp/
│
├── Pages/              # Razor Pages
├── wwwroot/            # Static files (CSS, JS, images)
├── Program.cs          # Application entry point
├── appsettings.json    # Configuration settings
└── basic-dotnet-webapp.csproj
```

---

## 🎯 What You Learned

* Installed the .NET SDK
* Created a web app using .NET templates
* Built and ran an ASP.NET Core application locally

---

## 📌 Next Steps (Optional)

* Add a **Dockerfile** for containerization
* Push the project to **GitHub**
* Deploy to **Azure App Service / AWS Elastic Beanstalk**
* Integrate **CI/CD pipelines**

---

## 🤝 Author

**Atul Kamble**
Cloud & DevOps Architect | Trainer
🔗 GitHub: [https://github.com/atulkamble](https://github.com/atulkamble)
🔗 LinkedIn: [https://www.linkedin.com/in/atuljkamble/](https://www.linkedin.com/in/atuljkamble/)

---

## 🚀 Basic .NET Web App Deployment using Azure CLI

![Image](https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/_images/basic-app-service-architecture-flow.svg?utm_source=chatgpt.com)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1200/1%2ALGnt_avJ0RbzxUxvWWKv4A.png?utm_source=chatgpt.com)

![Image](https://azure.microsoft.com/en-us/blog/wp-content/uploads/2017/09/AppServiceOnLinux.webp?utm_source=chatgpt.com)

![Image](https://k21academy.com/wp-content/uploads/2021/05/Figure-2-Service-Fabric-running-App-Service.png?utm_source=chatgpt.com)

---

## 🔧 Prerequisites

Make sure you have the following installed:

| Tool                   | Purpose                   |
| ---------------------- | ------------------------- |
| **.NET SDK (6/7/8)**   | Build & run the web app   |
| **Azure CLI**          | Deploy resources to Azure |
| **VS Code** (optional) | Code editing              |
| **Azure Subscription** | Required for deployment   |

Verify installations:

```bash
dotnet --version
az --version
```

Login to Azure:

```bash
az login
```

---

## 📁 Step 1: Create a Basic .NET Web App

Create a new folder and project:

```bash
mkdir dotnet-webapp
cd dotnet-webapp
dotnet new webapp -n MyWebApp
cd MyWebApp
```

Run locally to test:

```bash
dotnet run
```

Access in browser:

```
http://localhost:5000
```

---

## ☁️ Step 2: Create Azure Resources using Azure CLI

### 1️⃣ Set variables (recommended)

```bash
RESOURCE_GROUP=rg-dotnet-webapp
LOCATION=eastus
APP_SERVICE_PLAN=asp-dotnet-webapp
WEBAPP_NAME=mydotnetwebapp$RANDOM
```

---

### 2️⃣ Create Resource Group

```bash
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION
```

---

### 3️⃣ Create App Service Plan

```bash
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP \
  --sku B1 \
  --is-linux
```

---

### 4️⃣ Create Web App (Linux + .NET)

```bash
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --name $WEBAPP_NAME \
  --runtime "DOTNET|10.0"
```

---

## 📦 Step 3: Deploy the .NET App

Publish the app:

```bash
dotnet publish -c Release
```

Create a ZIP package:

```bash
cd bin/Release/net10.0/publish
zip -r app.zip .
```

Deploy using Azure CLI:

```bash
az webapp deploy \
  --resource-group $RESOURCE_GROUP \
  --name $WEBAPP_NAME \
  --src-path app.zip \
  --type zip
```

---

## 🌐 Step 4: Access the Application

Open in browser:

```bash
az webapp browse \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP
```

URL format:

```
https://<webapp-name>.azurewebsites.net
```

---

## 📊 Optional: View Logs (Troubleshooting)

Enable logs:

```bash
az webapp log config \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP \
  --web-server-logging filesystem
```

Stream logs:

```bash
az webapp log tail \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP
```

---

## 🧹 Cleanup (Important for Cost Control)

```bash
az group delete \
  --name $RESOURCE_GROUP \
  --yes \
  --no-wait
```

---

## 🧠 Architecture Overview

![Image](https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/_images/basic-app-service-architecture-flow.svg?utm_source=chatgpt.com)

![Image](https://learn.microsoft.com/en-us/azure/devops/pipelines/architectures/media/azure-pipelines-app-service-variant-architecture.svg?view=azure-devops\&utm_source=chatgpt.com)

![Image](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/media/image1-5.png?utm_source=chatgpt.com)

**Flow:**

```
Developer → Azure CLI → App Service → .NET Runtime → Public URL
```

---

## 📌 Key Takeaways

* Azure App Service is **PaaS** → no VM management
* Supports **CI/CD** (GitHub Actions, Azure DevOps)
* Scales easily (manual or auto-scale)
* Best for **training, demos, and production-ready apps**

---
