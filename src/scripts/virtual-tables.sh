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

resourceGroup=$environmentName
serverName="${resourceGroup}-server"
databaseName='legacy-pokemon-db'

# setup azure resources
./src/scripts/setup-azure-infrastructure.sh $azureTenant $subscription $resourceGroup $serverName $databaseName
./src/scripts/deploy-pokemon-abilities-to-database.sh $serverName $databaseName

serverName_environmentVariableValueFile=src/dataverseSolutions/UDPP25_VirtualTables/src/environmentvariabledefinitions/server_VCP_DS_16a0c4f7-9d50-43b8-9ad9-a564b45380cb/environmentvariablevalues.json
databaseName_environmentVariableValueFile=src/dataverseSolutions/UDPP25_VirtualTables/src/environmentvariabledefinitions/database_VCP_DS_16a0c4f7-9d50-43b8-9ad9-a564b45380cb/environmentvariablevalues.json

sed -i "s/\"value\": \".*\"/\"value\": \"$serverName.database.windows.net\"/" $serverName_environmentVariableValueFile
sed -i "s/\"value\": \".*\"/\"value\": \"$databaseName\"/" $databaseName_environmentVariableValueFile
dotnet build ./src/dataverseSolutions/UDPP25_VirtualTables --configuration Release

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nSign in to Power Platform in the browser...\n\n\033[0m"

# the solution must be deployed manually
# due to the Power Platform not supporting change
# of the connection reference instance at run time
# TODO: https://learn.microsoft.com/en-us/power-platform/alm/conn-ref-env-variables-build-tools
# pacBin=~/.dotnet/tools/pac
# $pacBin auth create
# $pacBin solution import \
#   --path ./src/dataverseSolutions/UDPP25_VirtualTables/bin/Release/UDPP25_VirtualTables.zip \
#   --environment "https://$environmentName.crm4.dynamics.com"

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nYou have to deploy the solution manually :/.\n\n\033[0m"