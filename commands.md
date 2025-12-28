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





```
