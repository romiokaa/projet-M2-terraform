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

variable "function_principal_id" {
  type        = string
  default     = null 
}

variable "allowed_ip" {
  type        = string
  description = "IP autorisée pour le firewall"
}

variable "admin_email" {
  type        = string
  description = "Adresse email qui recevra les alertes de monitoring"
}

variable "suffix" { type = string }