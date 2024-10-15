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

# Clear az login accounts
az account clear
# Set core.enable_broker_on_windows to false to avoid login error
az config set core.enable_broker_on_windows=false
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

Write-Host "Installing app proxy package"
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

.\RegisterConnector.ps1 -modulePath "C:\Program Files\Microsoft Entra private network connector\Modules\" -moduleName "MicrosoftEntraPrivateNetworkConnectorPSModule" -Authenticationmode Token -Token $SecureToken -TenantId $TenantId -Feature ApplicationProxy


# Create Scheduled task to restart the WAPCSvc service


# Define the log folder and log file path
$logFolderPath = "C:\Temp\Logs"
$logFilePath = "$logFolderPath\WAPCSvcCheck.log"

# Define the URL for the script
# $scriptUrl = "https://raw.githubusercontent.com/hmcts/azure-app-proxy/main/components/app-proxy/CheckAndStartWAPCSvc.ps1"
$scriptUrl = "https://raw.githubusercontent.com/hmcts/azure-app-proxy/f7fda4209ec14c27fc1a36f4964e4799c791212f/components/app-proxy/CheckAndStartWAPCSvc.ps1"

# Define the location to save the downloaded script
$downloadedScriptPath = "C:\Temp\CheckAndStartWAPCSvc.ps1"

# Check if the directory exists, if not create it
$downloadDirectory = "C:\Temp"
if (-not (Test-Path -Path $downloadDirectory)) {
    New-Item -Path $downloadDirectory -ItemType Directory
}

# Download the script from the URL
Invoke-WebRequest -Uri $scriptUrl -OutFile $downloadedScriptPath

# Function to create a scheduled task to run the downloaded script
function CreateScheduledTask {
    $taskName = "CheckAndStartWAPCSvc"
    
    # Check if the scheduled task already exists
    $taskExists = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }
    
    if (-not $taskExists) {
        # Create the trigger to run every 15 minutes
        $trigger = New-ScheduledTaskTrigger -RepeatInterval (New-TimeSpan -Minutes 15) -AtStartup
        
        # Create the action to run the PowerShell script
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"$downloadedScriptPath`""
        
        # Define the principal (run as the SYSTEM account with highest privileges)
        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        
        # Register the scheduled task
        Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName $taskName -Description "Check if WAPCSvc is running and start if not."
        
        # Output to confirm that the task was created
        Write-Output "$(Get-Date): Scheduled task '$taskName' was created." >> $logFilePath
    } else {
        # Output if the task already exists
        Write-Output "$(Get-Date): Scheduled task '$taskName' already exists." >> $logFilePath
    }
}

# Create the scheduled task
CreateScheduledTask
