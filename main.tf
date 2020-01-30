provider "azurerm" {
  version         = "1.38.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg"
  location = "West US 2"

  tags = {
    environment = "dev"
    method      = "terraform"
  }
}