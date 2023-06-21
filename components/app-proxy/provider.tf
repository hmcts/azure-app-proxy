provider "azurerm" {
  features {}
  //Reform-CFT-Mgmt
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

terraform {
  #  backend "azurerm" {}
  required_version = "1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }
}
