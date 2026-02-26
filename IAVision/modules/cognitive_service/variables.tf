variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "project" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "S1"
}

variable "tags" {
  type    = map(string)
  default = {}
}