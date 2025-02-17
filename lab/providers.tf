terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.19.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "azurerm" {
  subscription_id = "b1939b25-807e-43a4-8f19-c1055b6d8fc4"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}