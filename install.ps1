Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser;
mkdir -f -p $PROFILE\..;
echo (curl https://github.com/iineolineii/ssh-copy-id.ps1/raw/refs/heads/main/ssh-copy-id.ps1).Content >> $PROFILE;
