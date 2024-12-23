function ssh-copy-id {
    param (
        [string]$hostname,
        [int]$port = 22
    )

    if (-not $hostname) {
        Write-Error "Please specify the IP address or hostname to configure passwordless login."
        return
    }

    if ($port -lt 1 -or $port -gt 65535) {
        Write-Error "Port $port is invalid. Please specify a value between 1 and 65535."
        return
    }

    $sshDir = "$HOME\.ssh"
    $idRsaPubPath = "$sshDir\id_rsa.pub"

    # Check if ~/.ssh/id_rsa exists
    if (-not (Test-Path $idRsaPubPath)) {
        Write-Host "SSH key not found, creating a new one..."
        ssh-keygen -t rsa -b 4096 -f $idRsaPubPath -N ""
    } else {
        Write-Host "Using existing key."
    }

    # Test if passwordless SSH is already set up
    Write-Host "Checking for passwordless login..."
    $errorOutput = ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 -p $port $hostname "exit" 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Key already copied, passwordless login is working."
        Write-Host "All set! Try testing passwordless login: ssh $hostname -p $port"
        return
    }

    # Analyze common errors
    switch -regex ($errorOutput) {
        "(Host key verification failed|Permission denied)" {
            Write-Host "Passwordless login is not set up."
        }
        "Connection refused" {
            Write-Error "Connection refused. Please check if port $port is open on the remote server."
            return
        }
        default {
            Write-Error "Unknown error connecting to $hostname on port ${port}: $errorOutput"
            return
        }
    }

    # Copy the public key to the remote host
    $publicKey = Get-Content $idRsaPubPath
    $command = "mkdir -p ~/.ssh && echo '$publicKey' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh"

    Write-Host "Copying key to server $hostname..."
    $copyError = ssh -o StrictHostKeyChecking=no -p $port $hostname $command 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Key successfully copied to $hostname."
        Write-Host "All set! Try testing passwordless login: ssh $hostname -p $port"
    } else {
        Write-Host $LASTEXITCODE
        Write-Error "Failed to copy the key. Error output: $copyError"
    }
}
