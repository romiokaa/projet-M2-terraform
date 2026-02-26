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
  
  allowed_ip = "88.172.50.36"
  admin_email = "maissaa.hachi@gmail.com"

  tags = {
    project = "ia-ocr"
    owner   = "admin"
    env     = terraform.workspace
  }
}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source              = "./modules/key_vault"
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

module "cognitive_service" {
  source              = "./modules/cognitive_service"
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
  principal_id         = module.my_functions.function_identity_principal_id
}

module "my_functions" {
  source              = "./modules/functions"
  project_name        = "mon-projet-ia"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  storage_account_name        = module.storage.storage_account_name
  storage_account_url  = "https://${module.storage.storage_account_name}.blob.core.windows.net"

  ai_vision_endpoint = module.cognitive_service.endpoint
  key_vault_uri      = module.key_vault.vault_uri
}


