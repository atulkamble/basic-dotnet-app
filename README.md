# Basic .NET Web Application

A comprehensive guide demonstrating how to create, build, and deploy a basic ASP.NET Core web application using .NET 10.0, including local development and Azure deployment options.

## 🚀 Overview

This repository contains:
- A basic ASP.NET Core Razor Pages web application
- Docker containerization setup
- Azure deployment scripts and documentation
- Step-by-step setup and deployment guides

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 10.0+ | Build & run the web app |
| Azure CLI | Latest | Deploy resources to Azure |
| Docker | Latest | Container support |
| Git | Latest | Version control |

### Verify Prerequisites

```bash
dotnet --version
az --version
docker --version
git --version
```

## 🏗️ Project Structure

```text
basic-dotnet-app/
├── Pages/                          # Razor Pages
│   ├── _ViewImports.cshtml         # View imports
│   ├── _ViewStart.cshtml           # View start
│   ├── Error.cshtml                # Error page
│   ├── Index.cshtml                # Home page
│   ├── Privacy.cshtml              # Privacy page
│   └── Shared/                     # Shared views
│       ├── _Layout.cshtml          # Layout template
│       └── _ValidationScriptsPartial.cshtml
├── Properties/
│   └── launchSettings.json         # Launch configuration
├── wwwroot/                        # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   └── lib/
├── Program.cs                      # Application entry point
├── appsettings.json               # Configuration settings
├── appsettings.Development.json   # Development settings
├── basic-dotnet-webapp.csproj     # Project file
├── Dockerfile                     # Docker configuration
└── README.md                      # This file
```

## 🔧 Local Development

### 1. Clone the Repository

```bash
git clone https://github.com/atulkamble/basic-dotnet-app.git
cd basic-dotnet-app
```

### 2. Build the Application

```bash
dotnet build
```

### 3. Run the Application

```bash
dotnet run
```

The application will be available at:
- HTTPS: `https://localhost:5001`
- HTTP: `http://localhost:5000`

### 4. Development with Hot Reload

For development with automatic reload on file changes:

```bash
dotnet watch run
```

## 🐳 Docker Support

### Build Docker Image

```bash
docker build -t basic-dotnet-webapp .
```

### Run Docker Container

```bash
docker run -d -p 8080:8080 --name dotnet-app basic-dotnet-webapp
```

Access the application at: `http://localhost:8080`

### Stop and Remove Container

```bash
docker stop dotnet-app
docker rm dotnet-app
```

## ☁️ Azure Deployment

### Option 1: Quick Deployment Script

Set environment variables:

```bash
export RESOURCE_GROUP="rg-dotnet-webapp"
export LOCATION="eastus"
export APP_SERVICE_PLAN="asp-dotnet-webapp"
export WEBAPP_NAME="mydotnetwebapp$RANDOM"
```

Deploy to Azure:

```bash
# Login to Azure
az login

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create App Service plan
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP \
  --sku B1 --is-linux

# Create web app
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --name $WEBAPP_NAME \
  --runtime "DOTNET|10.0"

# Deploy application
dotnet publish -c Release
cd bin/Release/net10.0/publish
zip -r ../app.zip .
cd ../../../../

az webapp deploy \
  --resource-group $RESOURCE_GROUP \
  --name $WEBAPP_NAME \
  --src-path bin/Release/net10.0/app.zip \
  --type zip
```

### Option 2: Using Azure App Service Extension

1. Install the Azure App Service extension for VS Code
2. Right-click on the project folder
3. Select "Deploy to Web App..."
4. Follow the prompts to create and deploy

## 🔍 Monitoring and Troubleshooting

### Enable Application Logs

```bash
az webapp log config \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP \
  --web-server-logging filesystem
```

### Stream Live Logs

```bash
az webapp log tail \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP
```

### View Application in Browser

```bash
az webapp browse \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP
```

## 🧪 Testing

### Run Unit Tests

```bash
dotnet test
```

### Health Check

The application includes a basic health check endpoint at `/health` (if configured).

## 🔧 Configuration

### Environment-Specific Settings

- `appsettings.json` - Base configuration
- `appsettings.Development.json` - Development overrides
- `appsettings.Production.json` - Production overrides (create as needed)

### Key Configuration Options

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

## 🧹 Cleanup Resources

To avoid ongoing charges, delete the resource group when done:

```bash
az group delete --name $RESOURCE_GROUP --yes --no-wait
```

## 🚀 Next Steps

- [ ] Add authentication and authorization
- [ ] Implement database integration
- [ ] Set up CI/CD pipelines
- [ ] Add comprehensive logging and monitoring
- [ ] Implement caching strategies
- [ ] Add API endpoints
- [ ] Set up automated testing

## 🛡️ Security Considerations

- Enable HTTPS in production
- Configure proper CORS policies
- Implement input validation
- Use secure headers
- Enable Application Insights for monitoring

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Atul Kamble**  
Cloud & DevOps Architect | Trainer

- 🔗 GitHub: [https://github.com/atulkamble](https://github.com/atulkamble)
- 🔗 LinkedIn: [https://www.linkedin.com/in/atuljkamble/](https://www.linkedin.com/in/atuljkamble/)

## 📚 Resources

- [ASP.NET Core Documentation](https://docs.microsoft.com/en-us/aspnet/core/)
- [.NET 10.0 Documentation](https://docs.microsoft.com/en-us/dotnet/)
- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/)
- [Docker Documentation](https://docs.docker.com/)

---

*Last updated: December 2024*
