# Check if $PROFILE's parent directory exists
$profileDir = Split-Path -Path $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

# Download the script and append it to the $PROFILE
$profileContent = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/iineolineii/ssh-copy-id.ps1/main/ssh-copy-id.ps1").Content
$profileContent | Out-File -Append -Encoding utf8 $PROFILE
