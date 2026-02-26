variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
  default = "Switzerland North"
}

variable "project" {
  type = string
  default = "projectName"
}

variable "sku_name" {
  type    = string
  default = "S1"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "suffix" {
    type = string
    default = "iQdHujl"
}