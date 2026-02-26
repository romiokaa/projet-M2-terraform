variable "resource_group_name" {
  description = "Nom Resource Group"
  type        = string
}

variable "location" {
  description = "Région"
  type        = string
}

variable "prefix" {
  description = "Préfixe nommage"
  type        = string
}

variable "environment" {
  description = "Environnement (dev/prod)"
  type        = string
}

variable "tags" {
  description = "Tags ressources"
  type        = map(string)
}