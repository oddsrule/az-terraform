provider "azurerm" {
  version         = "1.38.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg"
  location = "westus2"

  tags = {
    environment = "dev"
    method      = "terraform"
  }
}