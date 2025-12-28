```

Tip: Updated code, dockerfile, dotnet setting for port no.80
Reference Code: https://github.com/atulkamble/basic-dotnet-app

0. Azure VM 

cd Downloads
chmod 400 vm_key.pem
ssh -i vm_key.pem azureuser@20.244.2.138


sudo apt update -y 
sudo apt install docker.io 
sudo systemctl start docker
sudo systemctl enable docker 
docker --version

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version
sudo az login 
sudo az acr login --name atulkamble


1. clone dotnet project code https://github.com/atulkamble/basic-dotnet-app.git

git clone https://github.com/atulkamble/basic-dotnet-app.git
cd basic-dotnet-app

2. Run locally 

dotnet build 
dotnet run 

http://localhost

3. Create ACR - Azure Container Registry 

4. Build Image 

sudo docker build -t atulkamble.azurecr.io/cloudnautic/basic-dotnet-app .
or
sudo docker buildx build -t atulkamble.azurecr.io/cloudnautic/basic-dotnet-app:latest --load .


5. Push Image to ACR 

sudo docker push atulkamble.azurecr.io/cloudnautic/basic-dotnet-app

6. Create webapp - name it - atulkamble859708

>> Container >> Plan - B1

7. set container port - 80 

8. check url of webapp 

https://mywebappatulkamble98600-h7cxhccgayejgff8.canadacentral-01.azurewebsites.net/

9. delete Resource Group 


// Deploy Dotnet App to Azure WebApp Servive using Azure Pipeline

https://github.com/atulkamble/basic-dotnet-app

1. Create Dotnet Project, Build, Run Locally 
2. Create Dockerfile (optional)
3. Push to Github Repo 
4. Create azure-pipelines.yml 
5. Create Project >> Azure Devops >> Create Pipeline >> select repo 
6. Pipeline settings >> service connection >> Azure Resource Manager >> select subscription, resource group,, AzureServiceConnection >> name it >> allow 
7. Pipeline >> azure-piplines.yml >> Service name, webapp name, resource group name 
8. Pipline Build and Run 
9. Azure WebApp Service URL >> Check 
10. troubleshooting 

Tip: Agent OS, Service conection, Pipeline Settings (Authorization) Allow

Stages - pipeline >> step by step >> Build >> Deploy 
Portal Settings >> Pipeline Setting should match as per Variables 

az webapp deploy 

Subscription ID: 50818730-e898-4bc4-bc35-d9983d719
Subscription Name: Pay-As-You-Go
Service Principal ID: 000e535c-f31e-4a10-a3a8-f06d5e326d
Service Principal Key: 03F8Q~4kqCey8wY-uoG5kPKkR4_e6XbQnbqM  

Tenant ID: bc281606-c655-4c05-90f2-49309a59c59f
Service connection name: Azure-BasicDotnetApp-Connection
Description: Service connection for basic dotnet webapp deployment

```
