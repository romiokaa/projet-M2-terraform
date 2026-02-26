terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}

}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source              = "../../modules/key_vault"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  project             = var.project
  env                 = var.env
  tags                = var.tags
}

resource "azurerm_key_vault_secret" "vision_key" {
  name         = "VISION-KEY"
  value        = module.cognitive_service.primary_key
  key_vault_id = module.key_vault.key_vault_id
}


resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.env}"
  location = var.location
  tags     = var.tags
}

module "cognitive_service" {
  source              = "../../modules/cognitive_service"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  env                 = var.env
  project             = var.project
  sku_name            = var.sku_name
  tags                = var.tags
}

output "vision_endpoint" {
  value = module.cognitive_service.endpoint
}

output "vision_key" {
  value     = module.cognitive_service.primary_key
  sensitive = true
}

resource "azurerm_role_assignment" "function_kv_access" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.function.function_principal_id
}