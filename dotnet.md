
## 🔹 1. .NET SDK & Environment Commands

![Image](https://assets.codeguru.com/uploads/2022/06/CLI-programming-tutorial.png?utm_source=chatgpt.com)

![Image](https://markheath.net/posts/2018/switching-between-netcore-sdk-versions-1.png?utm_source=chatgpt.com)

![Image](https://i.sstatic.net/vhRSa.png?utm_source=chatgpt.com)

| Command                  | Description                     |
| ------------------------ | ------------------------------- |
| `dotnet --version`       | Show installed .NET SDK version |
| `dotnet --info`          | Display SDK, runtime, OS info   |
| `dotnet --list-sdks`     | List installed SDKs             |
| `dotnet --list-runtimes` | List installed runtimes         |
| `dotnet help`            | Show CLI help                   |
| `dotnet help <command>`  | Help for a specific command     |

---

## 🔹 2. Project & Solution Management

![Image](https://images.hanselman.com/blog/Windows-Live-Writer/a2ea6b2dbb37_116F1/image_172e3b7d-b865-4ba5-be46-10b057ceca43.png?utm_source=chatgpt.com)

![Image](https://robertwray.co.uk/Media/Default/Blog/dotnetcore_solution_via_command_line.PNG?utm_source=chatgpt.com)

![Image](https://ardalis.com/img/dotnet-new-h.png?utm_source=chatgpt.com)

### 📌 Create Projects

```bash
dotnet new list
dotnet new console -n MyConsoleApp
dotnet new webapp -n MyWebApp
dotnet new mvc -n MyMvcApp
dotnet new webapi -n MyApi
dotnet new classlib -n MyLibrary
dotnet new sln -n MySolution
```

### 📌 Solution Commands

```bash
dotnet sln list
dotnet sln add MyApp.csproj
dotnet sln remove MyApp.csproj
```

---

## 🔹 3. Build, Run & Test

![Image](https://mattwarren.org/images/2016/10/dotnet-go-cmd-output.png?utm_source=chatgpt.com)

![Image](https://learn.microsoft.com/en-us/dotnet/core/tutorials/media/debugging-with-visual-studio-code/run-modified-program.png?utm_source=chatgpt.com)

![Image](https://i.sstatic.net/EyCNT.png?utm_source=chatgpt.com)

| Command                 | Description            |
| ----------------------- | ---------------------- |
| `dotnet build`          | Compile the project    |
| `dotnet run`            | Build & run the app    |
| `dotnet run --no-build` | Run without rebuilding |
| `dotnet test`           | Run unit tests         |
| `dotnet clean`          | Clean build artifacts  |
| `dotnet restore`        | Restore NuGet packages |

---

## 🔹 4. Package (NuGet) Management

![Image](https://ardalis.com/img/dotnet-cli.png?utm_source=chatgpt.com)

![Image](https://devblogs.microsoft.com/dotnet/wp-content/uploads/sites/10/2013/06/2541.EnablePackageRestore.png?utm_source=chatgpt.com)

![Image](https://user-images.githubusercontent.com/119940912/221855314-1c7da2de-c60d-4020-8b56-b7216fb198f2.png?utm_source=chatgpt.com)

```bash
dotnet add package Newtonsoft.Json
dotnet remove package Newtonsoft.Json
dotnet list package
dotnet restore
dotnet nuget list source
dotnet nuget add source <URL>
```

---

## 🔹 5. Publish & Deployment

![Image](https://i.sstatic.net/xReYA.gif?utm_source=chatgpt.com)

![Image](https://learn.microsoft.com/en-us/troubleshoot/developer/webapps/aspnetcore/practice-troubleshoot-linux/media/2-1-create-configure-aspnet-core-applications/dotnet-publish.png?utm_source=chatgpt.com)

![Image](https://jonhilton.net/img/2016/08/Compiled-output.png?utm_source=chatgpt.com)

```bash
dotnet publish -c Release
dotnet publish -o ./publish
dotnet publish -r linux-x64
dotnet publish --self-contained true
```

📌 **Common Runtimes**

* `win-x64`
* `linux-x64`
* `osx-x64`

---

## 🔹 6. ASP.NET Core Specific

![Image](https://resources.jetbrains.com/help/img/rider/2025.3/launch_settings_generated.png?utm_source=chatgpt.com)

![Image](https://media.enlabsoftware.com/wp-content/uploads/2021/05/10161925/windir-environment-variable-via-C-WINDOWS-2.jpg?utm_source=chatgpt.com)

![Image](https://ardalis.com/img/dotnet-watch-test.png?utm_source=chatgpt.com)

```bash
dotnet watch run
dotnet dev-certs https --trust
dotnet run --urls=http://localhost:5000
```

---

## 🔹 7. Entity Framework Core (EF)

![Image](https://www.learnentityframeworkcore.com/images/efcore/migrations/add-migration/thumbnail-ef-core-add-migration.png?utm_source=chatgpt.com)

![Image](https://www.thereformedprogrammer.net/wp-content/uploads/2019/01/FiveTypesOfMigrations.png?utm_source=chatgpt.com)

![Image](https://www.learnentityframeworkcore.com/images/efcore/migrations/update-database/thumbnail-ef-core-update-database.png?utm_source=chatgpt.com)

```bash
dotnet tool install --global dotnet-ef
dotnet ef migrations add InitialCreate
dotnet ef migrations remove
dotnet ef database update
dotnet ef database drop
```

---

## 🔹 8. Global & Local Tools

![Image](https://user-images.githubusercontent.com/1374013/78841828-228fdf00-799a-11ea-9502-a68db9d686a2.png?utm_source=chatgpt.com)

![Image](https://user-images.githubusercontent.com/1374013/78842462-bd3ced80-799b-11ea-8884-43dd3efe153e.png?utm_source=chatgpt.com)

![Image](https://weblog.west-wind.com/images/2020/DotnetTools/DotnetToolList.png?utm_source=chatgpt.com)

```bash
dotnet tool install --global dotnet-ef
dotnet tool list --global
dotnet tool uninstall --global dotnet-ef
```

---

## 🔹 9. Diagnostics & Performance

![Image](https://images.hanselman.com/blog/Windows-Live-Writer/25b05d6f04e5_1384B/image_6.png?utm_source=chatgpt.com)

![Image](https://devblogs.microsoft.com/dotnet/wp-content/uploads/sites/10/2020/01/72020972-ce058800-3221-11ea-9abf-d4f7ba114dd2.png?utm_source=chatgpt.com)

![Image](https://images.hanselman.com/blog/Windows-Live-Writer/2f35ef303a79_BE96/image_150bfb26-b59f-480f-a681-eced8f227612.png?utm_source=chatgpt.com)

```bash
dotnet trace collect
dotnet dump collect
dotnet dump analyze
dotnet counters monitor
```

---

## 🔹 10. DevOps & CI/CD Friendly Commands

![Image](https://miro.medium.com/0%2Alhbz9vRWnbRl4xVS?utm_source=chatgpt.com)

![Image](https://learn.microsoft.com/en-us/dotnet/core/testing/media/test-report.png?utm_source=chatgpt.com)

![Image](https://miro.medium.com/1%2AqepRAVdra-_S0BpOry2ZiA.gif?utm_source=chatgpt.com)

```bash
dotnet restore
dotnet build --configuration Release
dotnet test --no-build
dotnet publish -c Release -o app_publish
```

✅ Used in **GitHub Actions**, **Azure Pipelines**, **AWS CodeBuild**

---

## 🔹 11. Useful Flags & Options

| Option                 | Purpose          |
| ---------------------- | ---------------- |
| `-c Release`           | Release build    |
| `-o <dir>`             | Output directory |
| `--no-restore`         | Skip restore     |
| `--no-build`           | Skip build       |
| `--verbosity detailed` | Detailed logs    |

---

## 🔹 12. Interview-Ready One-Liners 💡

```bash
dotnet new webapi
dotnet run
dotnet build -c Release
dotnet test
dotnet publish -o publish
```

---

