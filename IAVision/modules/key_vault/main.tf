resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.project}-${var.env}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"

  enable_rbac_authorization   = true
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7

  tags = var.tags
}