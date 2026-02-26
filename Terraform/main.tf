# Create a random name for the resource group using random_pet
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

# Create a resource group using the generated random name
resource "azurerm_resource_group" "example" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

module "storage" {
  source = "./modules/storage"
  # ... variables de ta camarade
}

module "my_functions" {
  source              = "./modules/functions"
  project_name        = "mon-projet-ia"
  location            = "North Europe"
  resource_group_name = "ton-rg-existant"

  # On récupère les outputs de Maaissa
  storage_account_name       = module.storage.account_name
  storage_account_access_key = module.storage.primary_key
  blob_connection_string     = module.storage.connection_string
}

# Brassica utilise l'ID de TA fonction pour donner les accès
resource "azurerm_role_assignment" "storage_access" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.my_functions.function_identity_principal_id
}
