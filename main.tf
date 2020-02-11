# Bring in Azure Provider
provider "azurerm" {
  version = "1.38.0"
}

data "azurerm_client_config" "current"{}

# random passphrase to use on ssh key
resource "random_string" "passphrase" {
  length           = 12
  special          = true
  override_special = "!@#$%&*-_=?"
  number           = true
}

# Local resource call to generate ssh key
#resource "null_resource" "bastionkg" {
#  provisioner "local-exec" {
#    command = "ssh-keygen -f ${var.file-path}${var.prefix} -t rsa -b 4096 -N ${random_string.passphrase.result}"
#  }
#}

# get the ssh key generated above
#data "local_file" "sshpk" {
#    # private key
#    depends_on = [null_resource.bastionkg]
#    filename = "${var.file-path}${var.prefix}"
#}

#data "local_file" "sshpub" {
#    # public key
#    depends_on = [null_resource.bastionkg]
#    filename = "${var.file-path}${azurerm_virtual_machine.bastion.name}.pub"
#}

resource "azurerm_resource_group" "computerg" {
  name     = var.computerg
  location = var.location
  tags = {
    environment = var.landscape
    method      = "Terraform"
  }
}

data "azurerm_resource_group" "networkrg" {
  name = var.networkrg
}

#resource "azurerm_key_vault" "terraform-kv" {
#  name                        = "${azurerm_resource_group.rg.name}-akv"
# location                    = azurerm_resource_group.rg.location
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

resource "random_string" "storage" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                      = "${azurerm_resource_group.computerg.name}${random_string.storage.result}-sta"
  resource_group_name       = azurerm_resource_group.computerg.name
  location                  = azurerm_resource_group.computerg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  tags                      = azurerm_resource_group.computerg.tags
}

data "azurerm_virtual_network" "vnet" {
  name                      = var.vnet
  resource_group_name       = var.networkrg
}

#output "virtual_network_id" {
#  value = "${data.azurerm_virtual_network.vnet.id}"
#}

#output "virtual_network_name" {
#  value = "${data.azurerm_virtual_network.vnet.name}"
#}

data "azurerm_subnet" "bastion_subnet" {
  name                 = "${var.vnet}-${var.bastion_subnet}"
  virtual_network_name = var.vnet
  resource_group_name  = var.networkrg
}

data "azurerm_subnet" "dmz_subnet" {
  name                 = "${var.vnet}-${var.dmz_subnet}"
  virtual_network_name = var.vnet
  resource_group_name  = var.networkrg
}

data "azurerm_subnet" "web_subnet" {
  name                 = "${var.vnet}-${var.web_subnet}"
  virtual_network_name = var.vnet
  resource_group_name  = var.networkrg
}

data "azurerm_subnet" "db_subnet" {
  name                 = "${var.vnet}-${var.database_subnet}"
  virtual_network_name = var.vnet
  resource_group_name  = var.networkrg
}

data "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group
  resource_group_name = var.networkrg
}

data "azurerm_application_security_group" "bastion_asg" {
  name                = var.bastion_asg
  resource_group_name = var.networkrg
}

data "azurerm_application_security_group" "dmz_asg" {
  name                = var.dmz_asg
  resource_group_name = var.networkrg
}

data "azurerm_application_security_group" "web_asg" {
  name                = var.web_asg
  resource_group_name = var.networkrg
}

data "azurerm_application_security_group" "database_asg" {
  name                = var.database_asg
  resource_group_name = var.networkrg
}

resource "azurerm_public_ip" "public_ip" {
  name                    = "bastion-public-ip"
  location                = var.location
  resource_group_name     = data.azurerm_resource_group.networkrg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  tags                    = data.azurerm_resource_group.networkrg.tags
}

#data "azurerm_public_ip" "publicip" {
#  name                = azurerm_public_ip.public_ip.name
#  resource_group_name = azurerm_resource_group.computerg.name
#}

#resource "random_id" "bastion_nic" {
#  byte_length = 8
#}

resource "azurerm_network_interface" "bastion_nic" {
  name                = "bastion-nic"
  resource_group_name = azurerm_resource_group.computerg.name
  location            = azurerm_resource_group.computerg.location
  tags                = azurerm_resource_group.computerg.tags

  ip_configuration {
    name                          = "${var.bastion_prefix}-ipconfig-1"
    subnet_id                     = data.azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

}

resource "azurerm_virtual_machine" "bastion_server" {
  name                             = "bastion"
  location                         = azurerm_resource_group.computerg.location
  resource_group_name              = azurerm_resource_group.computerg.name
  network_interface_ids            = [azurerm_network_interface.bastion_nic.id]
  vm_size                          = "Standard_B1ls"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.7"
    version   = "latest"
  }

  storage_os_disk {
    name          = "bastionOsDisk"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "bastion"
    admin_username = "kirk"
    admin_password = "str0ngP2ssword!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
#    ssh_keys {
#      key_data = file(data.local_file.sshpub)
#      path     = "/home/kirk/.ssh/authorized_keys"
#    }
  }  
  tags = azurerm_resource_group.computerg.tags
}

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
