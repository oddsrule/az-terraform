provider "azurerm" {
  version = "1.38.0"
}

data "azurerm_client_config" "current"{}

variable "tenantId" {
  type    = string
  default = "6f41529f-662d-4409-9a0d-23208f94d525"
}

variable "objectId" {
  type    = string
  default = "05e80a1f-fcc8-4c53-9905-4e7f72a1cef8"
}

resource "azurerm_resource_group" "rg" {
  name     = var.app
  location = "westus2"
  tags = {
    environment = var.landscape
    method      = "terraform"
  }
}

#resource "azurerm_key_vault" "terraform-kv" {
#  name                        = "kjkvazure76876"
#  location                    = azurerm_resource_group.rg.location
#  resource_group_name         = azurerm_resource_group.rg.name
#  enabled_for_disk_encryption = false
#  tenant_id                   = data.azurerm_client_config.current.tenant_id
#  
#  sku_name = "standard"
#
#  access_policy {
#    tenant_id = data.azurerm_client_config.current.tenant_id
#    object_id = var.objectId
#
#    certificate_permissions = [
#      "get",
#      "list",
#    ]
#
#    key_permissions = [
#      "get",
#      "create",
#      "list",
#    ]
#
#    secret_permissions = [
#      "get",
#      "list",
#      "set",
#    ]
#
#    storage_permissions = [
#      "get",
#      "list",
#    ]
#  }
#
#  network_acls {
#    default_action = "Deny"
#    bypass         = "AzureServices"
#  }
#  enabled_for_deployment = true
#
#  tags = azurerm_resource_group.rg.tags
#}
#
#resource "random_id" "storage_account" {
#  byte_length  = 8
#}
#
#resource "azurerm_storage_account" "sa" {
#  name                      = random_id.storage_account.hex
#  resource_group_name       = azurerm_resource_group.rg.name
#  location                  = azurerm_resource_group.rg.location
#  account_kind              = "StorageV2"
#  account_tier              = "Standard"
#  account_replication_type  = "LRS"
#  enable_https_traffic_only = true
#  tags                      = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_virtual_network" "vnet" {
#  name                      = join("-", [azurerm_resource_group.rg.name, var.virtualNetwork1])
#  location                  = azurerm_resource_group.rg.location
#  resource_group_name       = azurerm_resource_group.rg.name
#  address_space             = ["10.0.0.0/16"]
#  tags                      = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_subnet" "bastion" {
#  virtual_network_name = azurerm_virtual_network.vnet.name
#  name                 = "BastionSubnet"
#  address_prefix       = "10.0.1.0/24"
#  resource_group_name  = azurerm_resource_group.rg.name
#}
#
#resource "azurerm_subnet" "dmz" {
#  virtual_network_name = azurerm_virtual_network.vnet.name
#  name                 = "DMZSubnet"
#  address_prefix       = "10.0.2.0/24"
#  resource_group_name  = azurerm_resource_group.rg.name
#}
#
#resource "azurerm_subnet" "web" {
#  virtual_network_name = azurerm_virtual_network.vnet.name
#  name                 = "WebSubnet"
#  address_prefix       = "10.0.3.0/24"
#  resource_group_name  = azurerm_resource_group.rg.name
#}
#
#resource "azurerm_subnet" "db" {
#  virtual_network_name = azurerm_virtual_network.vnet.name
#  name                 = "DBSubnet"
#  address_prefix       = "10.0.4.0/24"
#  resource_group_name  = azurerm_resource_group.rg.name
#}
#
#resource "azurerm_network_security_group" "nsg" {
#  name                = join("-", [azurerm_virtual_network.vnet.name, "nsg"])
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  tags                = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_application_security_group" "asgbst" {
#  name                = join("-", [azurerm_network_security_group.nsg.name, var.bastion])
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  tags                = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_application_security_group" "asgdmz" {
#  name                = join("-", [azurerm_network_security_group.nsg.name, var.dmz])
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  tags                = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_application_security_group" "asgweb" {
#  name                = join("-", [azurerm_network_security_group.nsg.name, var.web])
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  tags                = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_application_security_group" "asgdb" {
#  name                = join("-", [azurerm_network_security_group.nsg.name, var.db])
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  tags                = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_network_security_rule" "bastioninternet" {
#  name                                       = "bastion-inbound-ssh"
#  resource_group_name                        = azurerm_resource_group.rg.name
#  network_security_group_name                = azurerm_network_security_group.nsg.name
#
#  protocol                                   = "Tcp"
#  access                                     = "Allow"
#  direction                                  = "Inbound"
#
#  priority                                   = 100
#  description                                = "Allow ssh from shaw to bastion subnet"
#  source_address_prefix                      = "184.75.215.242/32"
#  source_port_range                          = "*"
#  destination_port_range                     = "22"
#  destination_application_security_group_ids = [azurerm_application_security_group.asgbst.id]
#}
#
#resource "azurerm_public_ip" "bastionpublicip" {
#  name                = "bastionpublicip"
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  allocation_method   = "Dynamic"
#}
#
#data "azurerm_public_ip" "bastionpublicip" {
#  name                = azurerm_public_ip.bastionpublicip.name
#  resource_group_name = azurerm_resource_group.rg.name
#}
#
#output "bastion_public_ip_address" {
#  description = "public IP address of the bastion server is"
#  value       = data.azurerm_public_ip.bastionpublicip.ip_address
#}
#
#resource "azurerm_network_interface" "bastionnic" {
#  name                = join("-", [var.bastion, "-nic"])
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = azurerm_resource_group.rg.location
#  tags                = azurerm_resource_group.rg.tags
#
#  ip_configuration {
#    name                          = "ipconfig-1"
#    subnet_id                     = azurerm_subnet.bastion.id
#    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = azurerm_public_ip.bastionpublicip.id
#  }
#}
#
#resource "azurerm_virtual_machine" "bastion" {
#  name                             = join("-", [azurerm_resource_group.rg.name, var.bastion])
#  location                         = azurerm_resource_group.rg.location
#  resource_group_name              = azurerm_resource_group.rg.name
#  network_interface_ids            = [azurerm_network_interface.bastionnic.id]
#  vm_size                          = "Standard_B1ls"
#  delete_os_disk_on_termination    = true
#  delete_data_disks_on_termination = true
#
#  storage_image_reference {
#    publisher = "RedHat"
#    offer     = "RHEL"
#    sku       = "7.7"
#    version   = "latest"
#  }
#
#  storage_os_disk {
#    name          = "bastionOsDisk"
#    create_option = "FromImage"
#  }
#
#  os_profile {
#    computer_name   = "bastion"
#    admin_username  = "sysadmin"
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = true
#    ssh_keys {
#      key_data = file("/home/kirk/.ssh/id_rsa.pub")
#      path     = "/home/sysadmin/.ssh/authorized_keys"
#    }
#  }  
#  
#  tags = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_network_interface" "dmznic" {
#  name                = join("-", [var.dmz, "-nic"])
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = azurerm_resource_group.rg.location
#  tags                = azurerm_resource_group.rg.tags
#
#  ip_configuration {
#    name                          = "ipconfig-1"
#    subnet_id                     = azurerm_subnet.dmz.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}
#
#resource "azurerm_virtual_machine" "dmz" {
#  name                             = join("-", [azurerm_resource_group.rg.name, var.dmz])
#  location                         = azurerm_resource_group.rg.location
#  resource_group_name              = azurerm_resource_group.rg.name
#  network_interface_ids            = [azurerm_network_interface.dmznic.id]
#  vm_size                          = "Standard_B1ls"
#  delete_os_disk_on_termination    = true
#  delete_data_disks_on_termination = true
#
#  storage_image_reference {
#    publisher = "RedHat"
#    offer     = "RHEL"
#    sku       = "7.7"
#    version   = "latest"
#  }
#
#  storage_os_disk {
#    name          = "dmzOsDisk"
#    create_option = "FromImage"
#  }
#
#  os_profile {
#    computer_name   = "dmz"
#    admin_username  = "sysadmin"
#    admin_password  = "Passw0rd1234!"
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = false
#  }  
#  
#  tags = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_network_interface" "webnic" {
#  name                = join("-", [var.web, "-nic"])
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = azurerm_resource_group.rg.location
#  tags                = azurerm_resource_group.rg.tags
#
#  ip_configuration {
#    name                          = "ipconfig-1"
#    subnet_id                     = azurerm_subnet.web.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}
#
#resource "azurerm_virtual_machine" "web" {
#  name                             = join("-", [azurerm_resource_group.rg.name, var.web])
#  location                         = azurerm_resource_group.rg.location
#  resource_group_name              = azurerm_resource_group.rg.name
#  network_interface_ids            = [azurerm_network_interface.webnic.id]
#  vm_size                          = "Standard_B1ls"
#  delete_os_disk_on_termination    = true
#  delete_data_disks_on_termination = true
#
#  storage_image_reference {
#    publisher = "RedHat"
#    offer     = "RHEL"
#    sku       = "7.7"
#    version   = "latest"
#  }
#
#  storage_os_disk {
#    name          = "webOsDisk"
#    create_option = "FromImage"
#  }
#
#  os_profile {
#    computer_name   = "web"
#    admin_username  = "sysadmin"
#    admin_password  = "Passw0rd1234!"
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = false
#  }  
#  
#  tags = azurerm_resource_group.rg.tags
#}
#
#resource "azurerm_network_interface" "dbnic" {
#  name                = join("-", [var.db, "-nic"])
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = azurerm_resource_group.rg.location
#  tags                = azurerm_resource_group.rg.tags
#
#  ip_configuration {
#    name                          = "ipconfig-1"
#    subnet_id                     = azurerm_subnet.db.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}
#
#resource "azurerm_virtual_machine" "db" {
#  name                             = join("-", [azurerm_resource_group.rg.name, var.db])
#  location                         = azurerm_resource_group.rg.location
#  resource_group_name              = azurerm_resource_group.rg.name
#  network_interface_ids            = [azurerm_network_interface.dbnic.id]
#  vm_size                          = "Standard_B1ls"
#  delete_os_disk_on_termination    = true
#  delete_data_disks_on_termination = true
#
#  storage_image_reference {
#    publisher = "RedHat"
#    offer     = "RHEL"
#    sku       = "7.7"
#    version   = "latest"
#  }
#
#  storage_os_disk {
#    name          = "dbOsDisk"
#    create_option = "FromImage"
#  }
#
#  os_profile {
#    computer_name   = "db"
#    admin_username  = "sysadmin"
#    admin_password  = "Passw0rd1234!"
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = false
#  }  
#  
#  tags = azurerm_resource_group.rg.tags
#}
