<#
  .SYNOPSIS
  Fetches and installs AzureAD Application connector.

  .PARAMETER Username
  Username of the account to run az login with and fetch the user_impersonation token.

  .PARAMETER Password
  Password of the account to run az login with and fetch the user_impersonation token.

  .PARAMETER TenantId
  The tenant to install AzureAD Application connector to.

  .OUTPUTS
  None. .\Bootstrap-Application-Proxy.ps1 does not generate any output.

  .EXAMPLE
  PS> .\Bootstrap-Application-Proxy.ps1 -TenantId b0294656-c63d-4c49-bd13-8f1153c62cda -Username User -Password VerySecure
#>
param ([Parameter(Mandatory)][string]$Username, [Parameter(Mandatory)][string]$Password, [Parameter(Mandatory)][string]$TenantId)
$ErrorActionPreference = "Stop"
 
# Install az-cli (updates current version if already installed)
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi

Set-Alias -Name az -Value "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.cmd"
# Login as app-proxy user
az login --username $Username --password $Password --allow-no-subscriptions
# Get account token
try {
    $Token = $(az account get-access-token --resource-type 'aad-graph' --scope 'https://proxy.cloudwebappproxy.net/registerapp/user_impersonation' --query "accessToken" -o tsv)
    Write-Host "Fetched access token for account"
} catch {
    Write-Host "Error occurred while fetching the access token:`n$($_.Exception.Message)"
    exit 1
}

curl.exe https://download.msappproxy.net/Subscription/d3c8b69d-6bf7-42be-a529-3fe9c2e70c90/Connector/DownloadConnectorInstaller -o installer.exe

.\installer.exe REGISTERCONNECTOR="false" /q

$AppProxyFolder = "C:\Program Files\Microsoft Entra private network connector"

$attempts = 0
# it takes a bit of time for the application proxy folder to get created
while (-not(Test-Path -Path $AppProxyFolder\Modules)) {
    $attempts++
    Write-Host "App Proxy folder not found, sleeping for 5 seconds"
    Start-Sleep -Seconds 10

    if ($attempts -gt 6) {
        Write-Host "App Proxy folder not found after 30 seconds, exiting"
        exit 1
    }
}

cd $AppProxyFolder
$SecureToken = $Token | ConvertTo-SecureString -AsPlainText -Force

.\RegisterConnector.ps1 -modulePath "C:\Program Files\Microsoft Entra private network connector\Modules\" -moduleName "AppProxyPSModule" -Authenticationmode Token -Token $SecureToken -TenantId $TenantId -Feature ApplicationProxy