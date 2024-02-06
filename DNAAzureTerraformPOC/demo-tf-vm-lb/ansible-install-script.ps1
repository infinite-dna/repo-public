# ansible-install-script.ps1

# Install Chocolatey (package manager for Windows)
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Ansible using Chocolatey
choco install ansible -y
