variable "appstring" {
    type        = string
    description = "3 character code for application"
}

variable "landscape" {
    type        = string
    description = "3 character code for landscape - one of sbx/dev/qut/prd"
    default     = "sbx"
}

variable "cloud" {
    type        = string
    description = "3 character code for cloud/datacenter"
    default     = "arm"
}

variable "region" {
    type        = string
    description = "3 character code for cloud region"
    default     = "uw2"
}

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

variable "prefix" {
  type    = string
  default = "bastion"
}
