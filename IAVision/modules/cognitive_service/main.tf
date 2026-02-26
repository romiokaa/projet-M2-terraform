resource "azurerm_cognitive_account" "vision" {
  name                = "cv-${var.project}-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name

  kind     = "ComputerVision"
  sku_name = var.sku_name

  tags = merge(var.tags, {
    project = var.project
    env     = var.env
  })
}