# Bring in Azure Provider
provider "azurerm" {
  version = "1.38.0"
}

data "azurerm_client_config" "current"{}

resource "azurerm_resource_group" "network-rg" {
  name     = var.networkrg
  location = var.location
  tags     = {
    Environment = "Dev"
    Method      = "Terraform"
  }
}
resource "azurerm_virtual_network" "vnet" {
  name                      = var.vnet
  location                  = azurerm_resource_group.network-rg.location
  resource_group_name       = azurerm_resource_group.network-rg.name
  address_space             = ["10.0.0.0/16"]
  tags                      = azurerm_resource_group.network-rg.tags
}

resource "azurerm_subnet" "bastion" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "bastion-subnet"
  address_prefix       = "10.0.1.0/24"
  resource_group_name  = azurerm_resource_group.network-rg.name
}

resource "azurerm_subnet" "dmz" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "dmz-subnet"
  address_prefix       = "10.0.2.0/24"
  resource_group_name  = azurerm_resource_group.network-rg.name
}

resource "azurerm_subnet" "web" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "web-subnet"
  address_prefix       = "10.0.3.0/24"
  resource_group_name  = azurerm_resource_group.network-rg.name
}

resource "azurerm_subnet" "db" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "db-subnet"
  address_prefix       = "10.0.4.0/24"
  resource_group_name  = azurerm_resource_group.network-rg.name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${azurerm_virtual_network.vnet.name}-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  tags                = azurerm_resource_group.network-rg.tags
}

resource "azurerm_application_security_group" "bstasg" {
  name                = "${azurerm_resource_group.network-rg.name}-bstasg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  tags                = azurerm_resource_group.network-rg.tags
}

resource "azurerm_application_security_group" "dmzasg" {
  name                = "${azurerm_resource_group.network-rg.name}-dmzasg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  tags                = azurerm_resource_group.network-rg.tags
}

resource "azurerm_application_security_group" "webasg" {
  name                = "${azurerm_resource_group.network-rg.name}-webasg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  tags                = azurerm_resource_group.network-rg.tags
}

resource "azurerm_application_security_group" "dbaasg" {
  name                = "${azurerm_resource_group.network-rg.name}-dbaasg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  tags                = azurerm_resource_group.network-rg.tags
}

resource "azurerm_network_security_rule" "bastioninternet" {
  name                                       = "bastion-inbound-ssh"
  resource_group_name                        = azurerm_resource_group.network-rg.name
  network_security_group_name                = azurerm_network_security_group.nsg.name

  protocol                                   = "Tcp"
  access                                     = "Allow"
  direction                                  = "Inbound"

  priority                                   = 100
  description                                = "Allow ssh from shaw to bastion subnet"
  source_address_prefix                      = "184.75.215.242/32"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.bstasg.id]
}