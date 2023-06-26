#!/usr/bin/env bash

az login --username $(azure-app-proxy-user-email) --password $(azure-app-proxy-user-password) --allow-no-subscriptions
TOKEN=$(az account get-access-token --resource-type 'aad-graph' --scope 'https://proxy.cloudwebappproxy.net/registerapp/user_impersonation' --query accessToken)
echo "##vso[task.setvariable variable=TOKEN;isOutput=true;issecret=true]$TOKEN"
echo "Token generated: $TOKEN"