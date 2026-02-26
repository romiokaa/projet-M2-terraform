variable "resource_group_name" {
    type = string
    description = ""
}
variable "location" {
    type = string
    description = ""
}
variable "project_name" {
    type = string
    description = ""
}

# Infos venant du module Storage Maaissa
variable "storage_account_name" {
    type = string
    description = ""
}

variable "storage_account_url" {
    type = string
    description = ""
}

# Infos venant du module AI Vision Brassica
variable "ai_vision_endpoint" { 
    type = string
    description = "" 
}

 variable "key_vault_uri" {
   type = string
   description = "URI du Key Vault"
 }