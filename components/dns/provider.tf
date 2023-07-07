provider "azurerm" {
  features {}
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

# Provider for Dynatrace
provider "azurerm" {
  alias = "cftptl"
  features {}
  skip_provider_registration = true
  subscription_id            = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

terraform {
  #  backend "azurerm" {}
  required_version = "1.5.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }
}
