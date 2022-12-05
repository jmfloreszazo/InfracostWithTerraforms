# Deploys

## Samples TF

https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples

## Tutorials

https://docs.microsoft.com/en-us/azure/developer/terraform/

## How do you get data environment:

Open your PowerShell terminal [Azure CLI](https://docs.microsoft.com/es-es/cli/azure/install-azure-cli?view=azure-cli-latest):

```bash
az login
```

Option: `az login --use-device-code`

List accounts with `az account list` and set:

```bash
az account set --subscription="SUBSCRIPTION_ID"
```
Create a Service Principal and get

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID" --name="Azure-DevOps-Terraform"
```

Add new environment variables:

```bash
$Env:ARM_CLIENT_ID = "[YOUR_CLIENT_ID]"
$Env:ARM_CLIENT_SECRET = "[YOUR_CLIENT_SECRET]"
$Env:ARM_TENANT_ID = "[YOUR_TEANT_ID]"
$Env:ARM_SUBSCRIPTION_ID = "[YOUR_SUBSCRIPTION_ID]"
```

## You must create Terraform State

```bash
#!/bin/bash

$Env:RESOURCE_GROUP_NAME=YOUR_RESOURCE_GROUP_NAME
$Env:STORAGE_ACCOUNT_NAME=YOUR_STORAGE_ACCOUNT_NAME
$Env:CONTAINER_NAME=YOUR_CONTAINER_NAME

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location centralus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"

```
## You must add

For example there are the values of previously action

```json
    terraform {
    required_version = ">= 0.14"
        backend "azurerm" {
        storage_account_name = "YOUR_STORAGE_ACCOUNT_NAME"
        container_name = "YOUR_CONTAINER_NAME"
        key = "terraform-dev.tfstate"
        access_key = "YOUR_ACCESS_KEY"
        }    
    }

```

## And last in Azure DevOps

You must create a Release and in step **Terraform Init** section **AzureRM Backend Configuration** add **Key** with this value: 

```bash
terraform-[enviroment].tfstate
```
