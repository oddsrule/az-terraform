provider "azurerm" {
  version = "1.38.0"
}

variable "bastion" {
  type    = string
  default = "bst"
}

variable "dmz" {
  type    = string
  default = "dmz"
}

variable "web" {
  type    = string
  default = "web"
}

variable "db" {
  type    = string
  default = "db"
}
variable "virtualNetwork1" {
  type    = string
  default = "vnet01"
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

resource "azurerm_virtual_network" "vnet" {
  name                      = join("-", [azurerm_resource_group.rg.name, var.virtualNetwork1])
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  address_space             = ["10.0.0.0/16"]
  tags                      = azurerm_resource_group.rg.tags
  subnet {
    name           = join("-", [azurerm_resource_group.rg.name, var.bastion, "snet"])
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = join("-", [azurerm_resource_group.rg.name, var.dmz, "snet"])
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = join("-", [azurerm_resource_group.rg.name, var.web, "snet"])
    address_prefix = "10.0.3.0/24"
  }

  subnet {
    name           = join("-", [azurerm_resource_group.rg.name, var.db, "snet"])
    address_prefix = "10.0.4.0/24"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = join("-", [azurerm_virtual_network.vnet.name, "nsg"])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_application_security_group" "asgbst" {
  name                = join("-", [azurerm_network_security_group.nsg.name, var.bastion])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_application_security_group" "asgdmz" {
  name                = join("-", [azurerm_network_security_group.nsg.name, var.dmz])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_application_security_group" "asgweb" {
  name                = join("-", [azurerm_network_security_group.nsg.name, var.web])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_application_security_group" "asgdb" {
  name                = join("-", [azurerm_network_security_group.nsg.name, var.db])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
}

