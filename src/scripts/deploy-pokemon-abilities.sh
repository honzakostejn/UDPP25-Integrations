#!/bin/sh

# params
serverName='udpp25-server-backup'
databaseName='udpp25-db-backup'
bacpacFile='./assets/abilities.bacpac'
connectionString='Server=tcp:udpp25-server-backup.database.windows.net,1433;Initial Catalog=udpp25-db-backup;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication="Active Directory Default";'

dotnet tool install -g microsoft.sqlpackage
sqlPackageBin=~/.dotnet/tools/sqlpackage

$sqlPackageBin /a:import /tcs:"$connectionString" /sf:$bacpacFile