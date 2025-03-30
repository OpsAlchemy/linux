terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-jman-terraform-dev-uksouth-01"
    storage_account_name = "stterraformdevuksouth01"
    container_name       = "terraform-statefiles-container"
    key                  = "jin40.terraform.tfstate"
  }
  required_version = ">= 1.2.0"
}

provider "azurerm" {
  subscription_id = local.subscription_id
  features {}
}
