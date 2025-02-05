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

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nEnvironment '$environmentId' was successfully created!\n\n\033[0m"

# build & deploy the solution
sed -i "s/\"value\": \".*\"/\"value\": \"$environmentId\"/" $environmentId_environmentVariableValueFile
dotnet build ./src/dataverseSolutions/UDPP25_Dataflows --configuration Release

$pacBin solution import \
  --path ./src/dataverseSolutions/UDPP25_Dataflows/bin/Release/UDPP25_Dataflows.zip \
  --environment "https://$environmentName.crm4.dynamics.com"

printf "\033[0;31m\n>>> BREAKING NEWS ( ͡ᵔ ͜ʖ ͡ᵔ) <<<\033[0m"
printf "\033[0;31m\nSolution was successfully imported!\n\n\033[0m"