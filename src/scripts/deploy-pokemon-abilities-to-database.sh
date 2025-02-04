#!/bin/sh

# params
serverName=$1
databaseName=$2
bacpacFile='./assets/abilities.bacpac'
connectionString="Server=tcp:$serverName.database.windows.net,1433;Initial Catalog=$databaseName;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"

sqlPackageBin=~/.dotnet/tools/sqlpackage

$sqlPackageBin /a:import /tcs:"$connectionString" /sf:$bacpacFile