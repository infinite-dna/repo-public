output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address_1stVM" {
  value = azurerm_windows_virtual_machine.main.public_ip_address
}

output "public_ip_address_2ndVM" {
  value = azurerm_windows_virtual_machine.main_2.public_ip_address
}
