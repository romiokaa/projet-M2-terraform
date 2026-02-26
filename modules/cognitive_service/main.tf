resource "azurerm_cognitive_account" "vision" {
  name = "cv-${var.project}-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  kind     = "ComputerVision"
  sku_name = var.sku_name

    tags = var.tags

}

