# PowerShell script to switch user context

# Function to switch user
function Switch-User {
    param (
        [string]$username,
        [string]$domain
    )

    $fullUsername = "$domain\$username"
    
    # Determine the user's home directory
    $userHome = [System.IO.Path]::Combine("C:\Users", $username)

    # Check if the home directory exists
    if (-Not (Test-Path $userHome)) {
        Write-Error "The home directory for user $username does not exist."
        return
    }

    # Command to start a new PowerShell process as the specified user
    $command = "runas /user:$fullUsername ""cmd.exe /c cd /d $userHome && start powershell.exe -NoExit"""
    Invoke-Expression $command
}

# Main script
Write-Host "Enter the username you want to switch to: "
$username = Read-Host

Write-Host "Enter the domain: "
$domain = Read-Host

Switch-User -username $username -domain $domain
