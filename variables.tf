variable "tenantId" {
  type    = string
}

variable "storage_base_name" {
  type    = string
  default = ""
}

variable "objectId" {
  type    = string
}

variable "file-path" {
  type    = string
  default = "~/.keys"
}

variable "location" {
  type    = string
  default = ""
}

variable "networkrg" {
  type    = string
  default = ""
}

variable "vnet" {
  type    = string
  default = ""
}

variable "computerg" {
  type    = string
  default = ""
}

variable "landscape" {
  type    = string
  default = ""
}

variable "bastion_subnet" {
  type    = string
  default = ""
}

variable "dmz_subnet" {
  type    = string
  default = ""
}

variable "web_subnet" {
  type    = string
  default = ""
}

variable "database_subnet" {
  type    = string
  default = ""
}

variable "bastion_asg" {
  type    = string
  default = ""
}

variable "dmz_asg" {
  type    = string
  default = ""
}

variable "web_asg" {
  type    = string
  default = ""
}

variable "database_asg" {
  type    = string
  default = ""
}

variable "bastion_prefix" {
  type    = string
  default = ""
}

variable "dmz_prefix" {
  type    = string
  default = ""
}

variable "web_prefix" {
  type    = string
  default = ""
}

variable "database_prefix" {
  type    = string
  default = ""
}

variable "network_security_group" {
  type    = string
  default = ""
}