provider "azurerm" {
  features {}
  //Reform-CFT-Mgmt
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

# Provider for Splunk and Nessus
provider "azurerm" {
  alias = "soc"
  features {}
  skip_provider_registration = true
  subscription_id            = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

# Provider for Dynatrace
provider "azurerm" {
  alias = "cnp"
  features {}
  skip_provider_registration = true
  subscription_id            = var.cnp_vault_sub
}

terraform {
  backend "azurerm" {}
  required_version = "1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.59.0"
    }
  }
}
