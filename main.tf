locals {
  env      = terraform.workspace
  project  = "ia-ocr"
  sku_name = "S1"
  suffix = random_string.suffix.result

  tags = {
    project = local.project
    owner   = "admin"
    env     = local.env
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-ia"
  location = "Switzerland North"
}

module "storage" {
  source              = "./modules/storage"
  prefix              = "projetm2"
  environment         = terraform.workspace
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  function_principal_id = module.my_functions.function_identity_principal_id 
  suffix = local.suffix

  allowed_ip = "82.225.2.158"
  admin_email = "brassica943@gmail.com"
  tags                  = merge(local.tags, { component = "storage" })

}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source              = "./modules/key_vault"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  project             = var.project
  suffix              = local.suffix
  tags                = merge(local.tags, { component = "keyvault" }) 
}

resource "azurerm_key_vault_secret" "vision_key" {
  name         = "VISION-KEY"
  value        = module.cognitive_service.primary_key
  key_vault_id = module.key_vault.key_vault_id
}

module "cognitive_service" {
  source              = "./modules/cognitive_service"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  project             = var.project
  sku_name            = var.sku_name
  tags                = merge(local.tags, { component = "vision" })
}

output "vision_endpoint" {
  value = module.cognitive_service.endpoint
}


resource "azurerm_role_assignment" "function_kv_access" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.my_functions.function_identity_principal_id
}

module "my_functions" {
  source              = "./modules/functions"
  project_name        = "mon-projet-ia-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  storage_account_name        = module.storage.storage_account_name
  storage_account_url  = "https://${module.storage.storage_account_name}.blob.core.windows.net"

  ai_vision_endpoint = module.cognitive_service.endpoint
  key_vault_uri      = module.key_vault.vault_uri
}

resource "azurerm_role_assignment" "function_read_images" {
  scope                = module.storage.images_container_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = module.my_functions.function_identity_principal_id
}

resource "azurerm_role_assignment" "function_write_results" {
  scope                = module.storage.results_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.my_functions.function_identity_principal_id
}

resource "azurerm_role_assignment" "admin_kv_access" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}