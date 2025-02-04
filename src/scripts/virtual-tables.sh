#!/bin/sh

# params
environmentName=$1
azureTenant=$2
subscription=$3

if [ -z "$environmentName" ]; then
  echo "Please provide an environment name."
  exit 1
fi
if [ -z "$azureTenant" ]; then
  echo "Please provide an Azure tenant."
  exit 1
fi
if [ -z "$subscription" ]; then
  echo "Please provide an Azure subscription."
  exit 1
fi

resourceGroup='UDPP25'
serverName="${resourceGroup}-server"
databaseName='legacy-pokemon-db'

./src/scripts/setup-azure-infrastructure.sh $azureTenant $subscription $resourceGroup $serverName $databaseName
./src/scripts/deploy-pokemon-abilities-to-database.sh $serverName $databaseName