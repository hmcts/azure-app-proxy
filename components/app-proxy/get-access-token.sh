#!/usr/bin/env bash

# Change account location to keep roles for later steps
export AZURE_CONFIG_DIR=~/.azure-app-proxy-user

# Fetch params from terraform data source
eval "$(jq -r '@sh "username=\(.username) password=\(.password)"')"

# Outputs to /dev/null to only return valid JSON object
az login --username $username --password $password --allow-no-subscriptions > /dev/null
az account get-access-token --resource-type 'aad-graph' --scope 'https://proxy.cloudwebappproxy.net/registerapp/user_impersonation'