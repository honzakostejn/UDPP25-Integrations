#!/bin/sh

# params
serverName=$1
databaseName=$2
bacpacFile='./assets/abilities.bacpac'
connectionString="Server=tcp:$serverName.database.windows.net,1433;Initial Catalog=$databaseName;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"

sqlPackageBin=~/.dotnet/tools/sqlpackage

$sqlPackageBin /a:import /tcs:"$connectionString" /sf:$bacpacFile

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nDatabase was successfully restored from the bacpac file!\n\n\033[0m"