provider "azurerm" {
  features {}
}

locals {
  variables = yamldecode(file("variables.yml"))
}

resource "azurerm_resource_group" "example" {
  name     = local.variables.resource_group_name
  location = local.variables.reource_group_location
}