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

  tags = {
    project = "ia-ocr"
    owner   = "admin"
    env     = terraform.workspace
  }
}