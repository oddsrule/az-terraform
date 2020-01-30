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

resource "azurerm_storage_account" "sa" {
  name                      = "terraform-sa"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${azurerm_resource_group.rg.location}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  tags                      = "${azurerm_resource_group.rg.tags}"
}