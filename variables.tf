variable "tenantId" {
  type    = string
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

variable "db_subnet" {
  type    = string
  default = ""
}