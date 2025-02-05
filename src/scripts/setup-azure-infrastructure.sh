#!/bin/sh

# params
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

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nLogged in to Azure!\n\n\033[0m"

# get user details
userPrincipalName=$(az ad signed-in-user show --query userPrincipalName -o tsv)
userId=$(az ad signed-in-user show --query id -o tsv)
currentNetworkIp=$(curl -s ifconfig.me) # whitelist current client ip

# create resource group and the database
az group create --name $resourceGroup --location $location --output table

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nResource group was created!\n\n\033[0m"

az deployment group create \
  --resource-group $resourceGroup \
  --template-file ./infrastructure/azure-sql.bicep \
  --parameters serverName=$serverName \
               databaseName=$databaseName \
               adminUserPrincipalName=$userPrincipalName \
               adminUserId=$userId \
               whitelistIp=$currentNetworkIp \
  --output table

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nThe database was successfully created!\n\n\033[0m"

# az deployment group create \
#   --resource-group $resourceGroup \
#   --template-file ./infrastructure/storage-account.bicep \
#   --parameters storageName="$storageName" \
#                whitelistIp=$currentNetworkIp \
#   --output table

# printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
# printf "\033[0;31m\nThe storage account was successfully created!\n\n\033[0m"