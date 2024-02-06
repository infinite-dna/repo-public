resource "azurerm_resource_group" "rg" {
  location = local.variables.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
}
# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_pet" "prefix" {
  prefix = local.variables.prefix
  length = 1
}