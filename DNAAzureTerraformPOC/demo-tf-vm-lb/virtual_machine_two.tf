# Create virtual machine
resource "azurerm_windows_virtual_machine" "main_2" {
  name                  = "${var.prefix}-vm2"
  admin_username        = "azureuser2"
  admin_password        = "Password1234"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic_sec.id]
  size                  = "Standard_E2s_v3"

  os_disk {
    name                 = "myOsDisk2"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }


  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install_2" {
  name                       = "${random_pet.prefix.id}-wsi2"
  virtual_machine_id         = azurerm_windows_virtual_machine.main_2.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
      ;mkdir c:\demo 
      ;Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe -OutFile C:\demo\python-installer.exe
      ; Start-Process -Wait -FilePath C:\demo\python-installer.exe -ArgumentList '/quiet', 'InstallAllUsers=1', 'PrependPath=1'
      ; Remove-Item -Path C:\demo\python-installer.exe
      ; rmdir c:\demo
      ; python -m pip install --upgrade pip
      ; pip install ansible"
    }
  SETTINGS
}



#Set-ExecutionPolicy Bypass -Scope Process -Force ; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
#choco install ansible -y
