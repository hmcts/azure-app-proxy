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

provider "azurerm" {
  alias = "dcr"
  features {}
  subscription_id = var.env == "prod" || var.env == "production" ? "8999dec3-0104-4a27-94ee-6588559729d1" : var.env == "sbox" || var.env == "sandbox" ? "bf308a5c-0624-4334-8ff8-8dca9fd43783" : "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

terraform {
  backend "azurerm" {}
  required_version = "1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
  }
}
