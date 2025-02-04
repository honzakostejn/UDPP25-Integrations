#!/bin/sh

# params
pacBin=~/.dotnet/tools/pac
environmentId_environmentVariableValueFile=./src/dataverseSolutions/UDPP25_Dataflows/src/environmentvariabledefinitions/udpp25_DataverseEnvironmentId/environmentvariablevalues.json
environmentName=$1

if [ -z "$environmentName" ]; then
  echo "Please provide an environment name."
  exit 1
fi

# create environment
$pacBin auth create
environmentId=$($pacBin admin create \
  --name "$environmentName" \
  --type 'Developer' \
  --region 'europe' \
  --currency 'USD' \
  --domain "$environmentName" | tail -n 2 | head -n 1 | awk '{print $2}')

printf "\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<"
printf "\nEnvironment '$environmentId' was successfully created!\n\n"

# build & deploy the solution
sed -i "s/\"value\": \".*\"/\"value\": \"$environmentId\"/" $environmentId_environmentVariableValueFile
dotnet build ./src/dataverseSolutions/UDPP25_Dataflows --configuration Release

$pacBin solution import \
  --path ./src/dataverseSolutions/UDPP25_Dataflows/bin/Release/UDPP25_Dataflows.zip \
  --environment "https://$environmentName.crm4.dynamics.com"

printf "\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<"
printf "\nSolution was successfully imported!"