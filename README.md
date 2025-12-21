# 🚀 Basic .NET Web App Setup Guide

This repository demonstrates how to **install .NET**, **create a basic ASP.NET Core web application**, and **run it locally** using the .NET CLI.

---

## 📌 Prerequisites

Before you begin, ensure the following:

* 💻 **Operating System**: Windows (recommended for Chocolatey)
* 🧰 **Package Manager**: Chocolatey installed
* 🌐 **Internet Connection**

---

## 🔧 Step 1: Install .NET SDK

### Option 1: Install via Chocolatey (Recommended)

Open **PowerShell as Administrator** and run:

```powershell
choco install dotnet -y
```

### Option 2: Manual Installation

Download the latest .NET SDK from the official website:

🔗 [https://dotnet.microsoft.com/en-us/download](https://dotnet.microsoft.com/en-us/download)

---

## ✅ Step 2: Verify .NET Installation

Confirm that .NET is installed correctly:

```bash
dotnet --version
```

You should see the installed SDK version displayed.

---

## 🏗️ Step 3: Create a New Web Application

Use the built-in templates to create a basic ASP.NET Core web app:

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
  --runtime "DOTNET|8.0"
```

---

## 📦 Step 3: Deploy the .NET App

Publish the app:

```bash
dotnet publish -c Release
```

Create a ZIP package:

```bash
cd bin/Release/net8.0/publish
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
