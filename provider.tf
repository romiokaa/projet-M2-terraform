terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" 
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-M2-state" 
    storage_account_name = "storagem2projet" 
    container_name       = "tfstate"
    key                  = "storage.terraform.tfstate" 
  }
}

provider "azurerm" {
  features {} 

  resource_provider_registrations = "none"
}