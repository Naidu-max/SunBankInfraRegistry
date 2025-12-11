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
subscription_id = "75919d5e-05df-4e56-b257-f967e7fcd436"
      features {   }
      }




