variable "appstring" {
    type        = string
    description = "3 character code for application"
}

variable "landscape" {
    type        = string
    description = "3 character code for landscape - one of sbx/dev/qut/prd"
    default     = ["sbx"]
}

variable "cloud" {
    type        = string
    description = "3 character code for cloud/datacenter"
}

variable "device" {
    type        = string
    description = "3 character code for type of device"
}

variable "region" {
    type        = string
    description = "3 character code for cloud region"
    default     = ["uw2"]
}

variable "number" {
    type        = number
    description = "iterated number to append to devices"
    default     = 000
}