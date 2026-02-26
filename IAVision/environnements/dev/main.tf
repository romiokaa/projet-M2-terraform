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