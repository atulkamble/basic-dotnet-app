# Basic .NET Web Application

A simple ASP.NET Core web application built with .NET 10, demonstrating the basics of Razor Pages web development.

## 🚀 Features

- **ASP.NET Core Razor Pages**: Server-side rendered web pages
- **Bootstrap CSS Framework**: Responsive and modern UI components
- **HTTPS Development Certificate**: Secure local development
- **Hot Reload**: Automatic refresh during development
- **Configuration Management**: Environment-specific settings

## 📋 Prerequisites

- [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0) or later
- A code editor (Visual Studio, Visual Studio Code, or any text editor)
- Web browser

## 🛠️ Installation & Setup

1. **Clone or download** this repository to your local machine

2. **Navigate** to the project directory:
   ```bash
   cd basic-dotnet-app
   ```

3. **Restore dependencies**:
   ```bash
   dotnet restore
   ```

4. **Trust the development certificate** (first time only):
   ```bash
   dotnet dev-certs https --trust
   ```

## ▶️ Running the Application

### Development Mode
```bash
dotnet run
```

The application will start and be available at:
- **HTTPS**: `https://localhost:5001`
- **HTTP**: `http://localhost:5000`

### Watch Mode (Hot Reload)
```bash
dotnet watch run
```

This enables automatic recompilation and browser refresh when you make changes to the code.

## 🏗️ Project Structure

```
basic-dotnet-app/
├── Pages/                          # Razor Pages
│   ├── Shared/                     # Shared layouts and components
│   │   ├── _Layout.cshtml         # Main layout template
│   │   ├── _Layout.cshtml.cs      # Layout code-behind
│   │   └── _ViewImports.cshtml    # Global using statements
│   ├── Error.cshtml               # Error page
│   ├── Error.cshtml.cs           # Error page model
│   ├── Index.cshtml               # Home page
│   ├── Index.cshtml.cs           # Home page model
│   ├── Privacy.cshtml             # Privacy page
│   └── Privacy.cshtml.cs         # Privacy page model
├── Properties/
│   └── launchSettings.json        # Launch configuration
├── wwwroot/                        # Static files (CSS, JS, images)
│   ├── css/                       # Stylesheets
│   ├── js/                        # JavaScript files
│   └── lib/                       # Third-party libraries
├── appsettings.json               # Application configuration
├── appsettings.Development.json   # Development-specific settings
├── BasicDotNetApp.csproj         # Project file
├── Program.cs                     # Application entry point
└── README.md                      # This file
```

## 🔧 Configuration

### Application Settings
- **appsettings.json**: Production configuration
- **appsettings.Development.json**: Development-specific overrides

### Launch Settings
Configure ports, environment variables, and launch profiles in `Properties/launchSettings.json`.

## 🎨 Customization

### Adding New Pages
1. Create a new `.cshtml` file in the `Pages` directory
2. Add a corresponding `.cshtml.cs` file with the page model
3. Navigation will be automatically available

### Styling
- Modify `wwwroot/css/site.css` for custom styles
- Bootstrap 5 is included by default
- Additional CSS libraries can be added to `wwwroot/lib/`

### Layout Changes
- Edit `Pages/Shared/_Layout.cshtml` to modify the overall page structure
- Update navigation in the layout file

## 🧪 Testing

Run the application tests (when available):
```bash
dotnet test
```

## 📦 Building for Production

### Build the application:
```bash
dotnet build --configuration Release
```

### Publish the application:
```bash
dotnet publish --configuration Release --output ./publish
```

The published files will be in the `./publish` directory and can be deployed to any web server that supports ASP.NET Core.

## � Docker Support

This application includes Docker support for containerized deployment.

### Docker Files
- **Dockerfile**: Multi-stage build configuration for production deployment
- **.dockerignore**: Excludes unnecessary files from Docker build context

### Build Docker Image
```bash
docker build -t basic-dotnet-app .
```

### Run Docker Container
```bash
# Run in detached mode
docker run -d -p 5000:5000 --name my-dotnet-app basic-dotnet-app

# Run with interactive access
docker run -it -p 5000:5000 basic-dotnet-app
```

### Docker Features
- **Multi-stage build**: Optimized image size using SDK for build and runtime for execution
- **Security**: Runs as non-root user
- **Performance**: Layer caching for faster builds
- **Production ready**: Configured for production environment

## 🔄 CI/CD with Azure DevOps

The project includes Azure DevOps pipeline configurations for automated build and deployment.

### Pipeline Files
- **azure-pipelines.yml**: Main CI/CD pipeline with Docker support
- **azure-pipelines-deploy.yml**: Azure Web App deployment pipeline

### Main Pipeline Features (`azure-pipelines.yml`)
- **Multi-stage pipeline**: Separate build and Docker stages
- **Automated testing**: Runs unit tests with code coverage
- **Artifact publishing**: Creates deployable artifacts
- **Docker image creation**: Builds and saves Docker images
- **Branch triggers**: Runs on `main` and `develop` branches

### Deployment Pipeline Features (`azure-pipelines-deploy.yml`)
- **Azure Web App deployment**: Direct deployment to Azure
- **Environment gating**: Only deploys from `main` branch
- **Service connection**: Uses Azure service connection for secure deployment
- **Production environment**: Deployment jobs with approval gates

### Setup Instructions
1. **Import pipeline** in Azure DevOps
2. **Configure variables** in pipeline settings:
   - `azureSubscription`: Azure service connection name
   - `webAppName`: Target Azure Web App name  
   - `resourceGroupName`: Azure resource group name
3. **Set up service connection** to your Azure subscription
4. **Configure branch policies** if needed

### Pipeline Stages
1. **Build Stage**:
   - Install .NET 10 SDK
   - Restore NuGet packages
   - Build application
   - Run tests
   - Publish artifacts

2. **Docker Stage** (main pipeline):
   - Build Docker image
   - Tag with build ID and latest
   - Save image as artifact

3. **Deploy Stage** (deployment pipeline):
   - Deploy to Azure Web App
   - Use production environment gates

## �🚀 Deployment Options

- **Azure App Service**: Deploy directly to Azure
- **Docker**: Containerize the application
- **IIS**: Deploy to Internet Information Services
- **Linux**: Deploy to Linux servers with Kestrel
- **Self-contained**: Bundle the .NET runtime with the app

## 🔒 Security Features

- **HTTPS Redirection**: Automatically redirects HTTP to HTTPS
- **Anti-forgery Tokens**: CSRF protection on forms
- **Secure Headers**: Security-focused HTTP headers
- **Development Certificate**: Trusted HTTPS during development

## 📚 Learning Resources

- [ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core/)
- [Razor Pages Tutorial](https://docs.microsoft.com/aspnet/core/tutorials/razor-pages/)
- [.NET Documentation](https://docs.microsoft.com/dotnet/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Find and kill the process using the port
lsof -ti:5000 | xargs kill -9
```

**Certificate issues:**
```bash
# Clear and recreate development certificates
dotnet dev-certs https --clean
dotnet dev-certs https --trust
```

**Restore issues:**
```bash
# Clear NuGet cache and restore
dotnet nuget locals all --clear
dotnet restore
```

## 📞 Support

For questions and support:
- Check the [ASP.NET Core GitHub Issues](https://github.com/dotnet/aspnetcore/issues)
- Visit [Stack Overflow](https://stackoverflow.com/questions/tagged/asp.net-core)
- Review the [official documentation](https://docs.microsoft.com/aspnet/core/)

---

**Happy Coding!** 🎉