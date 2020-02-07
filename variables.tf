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
  default = "6f41529f-662d-4409-9a0d-23208f94d525"
}

variable "objectId" {
  type    = string
  default = "05e80a1f-fcc8-4c53-9905-4e7f72a1cef8"
}

variable "file-path" {
  type    = string
  default = "~/.keys"
}