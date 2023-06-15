<#
  .SYNOPSIS
  Fetches and installs AzureAD Application connector.

  .PARAMETER Token
  An AzureAD token with the applicaton administrator role or Directory.ReadWrite.All
  It can be generated with "az account get-access-token --resource-type aad-graph --scope https://proxy.cloudwebappproxy.net/registerapp/user_impersonation"

  .PARAMETER TenantId
  The tenant to install AzureAD Application connector to.

  .OUTPUTS
  None. .\Bootstrap-Application-Proxy.ps1 does not generate any output.

  .EXAMPLE
  PS> .\Bootstrap-Application-Proxy.ps1 -TenantId b0294656-c63d-4c49-bd13-8f1153c62cda -Token $Token
#>
param ([Parameter(Mandatory)][string] $Token, [Parameter(Mandatory)][string]$TenantId)
$ErrorActionPreference = "Stop"

curl.exe https://download.msappproxy.net/Subscription/d3c8b69d-6bf7-42be-a529-3fe9c2e70c90/Connector/DownloadConnectorInstaller -o installer.exe

.\installer.exe REGISTERCONNECTOR="false" /q

$AppProxyFolder = "C:\Program Files\Microsoft AAD App Proxy Connector"

$attempts = 0
# it takes a bit of time for the application proxy folder to get created
while (-not(Test-Path -Path $AppProxyFolder)) {
    $attempts++
    Write-Host "App Proxy folder not found, sleeping for 5 seconds"
    Start-Sleep -Seconds 5

    if ($attempts -gt 6) {
        Write-Host "App Proxy folder not found after 30 seconds, exiting"
        exit 1
    }
}

cd $AppProxyFolder
$SecureToken = $Token | ConvertTo-SecureString -AsPlainText -Force

.\RegisterConnector.ps1 -modulePath "C:\Program Files\Microsoft AAD App Proxy Connector\Modules\" -moduleName "AppProxyPSModule" -Authenticationmode Token -Token $SecureToken -TenantId $TenantId -Feature ApplicationProxy
