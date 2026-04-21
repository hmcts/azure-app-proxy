provider "azurerm" {
  features {}
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

terraform {
  backend "azurerm" {}

  required_version = "1.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}
