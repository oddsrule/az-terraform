provider "azurerm" {
  version = "1.38.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg"
  location = "westus2"
  tags = {
    environment = "dev"
    method      = "terraform"
  }
}

resource "random_id" "storage_account" {
  byte_length  = 8
}

resource "azurerm_storage_account" "sa" {
  name                      = random_id.storage_account.hex
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  tags                      = azurerm_resource_group.rg.tags
}

resource "azure_virtual_network" "vnet" {
  name                      = azurerm_resource_group.rg.name-vnet01
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  address_space             = ["10.0.0.0/16"]

  subnet {
    name           = azurerm_resource_group.rg.name-bst-snet
    address_prefix = "10.0.1.0/24"
  }
}