# `ssh-copy-id` PowerShell Port

This PowerShell function is a simple port of the `ssh-copy-id` utility designed for Windows.

It helps automate the setup of passwordless SSH login on a remote Linux server by copying your SSH public key to the server's `~/.ssh/authorized_keys` file.

This utility is specifically created for Windows users because the OpenSSH client on Windows *(somehow)* appears to not include the `ssh-copy-id` utility by default.

## Requirements:
- PowerShell version 5.1 or higher
- OpenSSH client installed (includes `ssh` and `ssh-keygen` utilities)

## Installation:
Use the following command to add `ssh-copy-id` function to your $PROFILE:
```powershell
echo (curl https://github.com/iineolineii/ssh-copy-id.ps1/raw/refs/heads/main/ssh-copy-id.ps1).Content >> $PROFILE
```

## Usage:
### Parameters:
- `hostname` (string): The IP address or hostname of the remote server.
- `port` (int): The SSH port of the remote server (default is 22).

### How to Use:
1. Ensure you have an SSH key pair in `~/.ssh/id_rsa.pub` (this function will create one if it doesn't exist).
2. Run the command with the appropriate parameters, like this:
   ```powershell
   ssh-copy-id <hostname> -p <port>
   ```

The function will:
1. Check if an RSA-encrypted SSH key already exists. If not, generate a new one.
2. Verify if passwordless SSH login is already configured.
3. If not, copy the public key to the remote server and set the appropriate permissions.

### Example:
To set up passwordless login for a server with IP address `192.168.1.23` using the default SSH port `22`, just run:
```powershell
ssh-copy-id 192.168.1.23
```

