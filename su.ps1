# PowerShell script to switch user context

# Function to switch user
function Switch-User {
    param (
        [string]$username,
        [string]$domain,
        [string]$password
    )

    $fullUsername = "$domain\$username"
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($fullUsername, $securePassword)
    
    # Determine the user's home directory
    $userHome = [System.IO.Path]::Combine("C:\Users", $username)

    # Check if the home directory exists
    if (-Not (Test-Path $userHome)) {
        Write-Error "The home directory for user $username does not exist."
        return
    }

    Start-Process powershell.exe -Credential $credential -ArgumentList '-NoExit' -WorkingDirectory $userHome
}

# Main script
Write-Host "Enter the username you want to switch to: "
$username = Read-Host

Write-Host "Enter the domain: "
$domain = Read-Host

Write-Host "Enter the password for ${username}@${domain}: "
$password = Read-Host -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Switch-User -username $username -domain $domain -password $password

