# Define the log folder and log file path
$logFolderPath = "C:\Temp\Logs"
$logFilePath = "$logFolderPath\WAPCSvcCheck.log"

# Check if the log folder exists, if not, create it
if (-not (Test-Path -Path $logFolderPath)) {
    New-Item -Path $logFolderPath -ItemType Directory
}

# Function to check and start WAPCSvc service
function CheckAndStartWAPCSvc {
    $service = Get-Service -Name 'WAPCSvc'
    if ($service.Status -ne 'Running') {
        # If the service is not running, attempt to start it
        Start-Service -Name 'WAPCSvc'
        # Log the action
        Write-Output "$(Get-Date): WAPCSvc service was not running and has been started." >> $logFilePath
    } 
}

# Check and start the service
CheckAndStartWAPCSvc