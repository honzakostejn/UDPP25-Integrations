#!/bin/sh

# params
# tenant='networg.com'
# subscription='a0ef3fdf-d7fc-4c93-89d2-a917d23cd8a3'
# location='northeurope'
# resourceGroup='UDPP25-backup'
# serverName='udpp25-server-backup'
# databaseName='udpp25-db-backup'
tenant=$1
subscription=$2
resourceGroup=$3
serverName=$4
databaseName=$5
location='northeurope'
storageName="${resourceGroup}storage"

# login to azure
az config set core.login_experience_v2=off
az login --allow-no-subscriptions --tenant $tenant --output none # --use-device-code
az account set --subscription $subscription

printf "\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<"
printf "\nLogged in to Azure!\n\n"

# get user details
userPrincipalName=$(az ad signed-in-user show --query userPrincipalName -o tsv)
userId=$(az ad signed-in-user show --query id -o tsv)
currentNetworkIp=$(curl -s ifconfig.me) # whitelist current client ip

# create resource group and the database
az group create --name $resourceGroup --location $location --output table

printf "\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<"
printf "\nResource group was created!\n\n"

az deployment group create \
  --resource-group $resourceGroup \
  --template-file ./infrastructure/azure-sql.bicep \
  --parameters serverName=$serverName \
               databaseName=$databaseName \
               adminUserPrincipalName=$userPrincipalName \
               adminUserId=$userId \
               whitelistIp=$currentNetworkIp \
  --output table

printf "\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<"
printf "\nThe database was successfully created!\n\n"

az deployment group create \
  --resource-group $resourceGroup \
  --template-file ./infrastructure/storage-account.bicep \
  --parameters storageName="$storageName" \
  --output table

printf "\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<"
printf "\nThe storage account was successfully created!\n\n"