# Download SQL Server Express installer
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=866658" -OutFile "C:\SQLServerInstaller.exe"

# Install SQL Server
Start-Process -Wait -FilePath "C:\SQLServerInstaller.exe" -ArgumentList "/IACCEPTSQLSERVERLICENSETERMS", "/QS", "/ACTION=Install", "/INSTANCENAME=MSSQLSERVER", "/FEATURES=SQLEngine", "/SECURITYMODE=SQL", "/SAPWD=YourStrongPassword", "/SQLSVCACCOUNT='NT AUTHORITY\SYSTEM'", "/SQLSYSADMINACCOUNTS='BUILTIN\ADMINISTRATORS'", "/AGTSVCACCOUNT='NT AUTHORITY\NETWORK SERVICE'"

# Remove the installer file
Remove-Item -Path "C:\SQLServerInstaller.exe" -Force

# Enable SQL Server services
Start-Service MSSQLSERVER
