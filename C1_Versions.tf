terraform {
    required_version = ">=1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=4.55.0"
    }
  random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }

}

}


provider "azurerm" {
subscription_id = "77618802-0818-4173-8674-95a126ef0cc2"
      features {   }
      }




