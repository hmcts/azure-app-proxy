locals {
  dynatrace_env = var.dynatrace_tenant_id == "yrk32651" ? "nonprod" : "prod"
}

# Splunk
data "azurerm_key_vault" "soc_vault" {
  provider            = azurerm.soc
  name                = "soc-prod"
  resource_group_name = "soc-core-infra-prod-rg"
}
data "azurerm_key_vault_secret" "splunk_username" {
  provider     = azurerm.soc
  name         = "splunk-gui-admin-username"
  key_vault_id = data.azurerm_key_vault.soc_vault.id
}
data "azurerm_key_vault_secret" "splunk_password" {
  provider     = azurerm.soc
  name         = "splunk-gui-admin-password"
  key_vault_id = data.azurerm_key_vault.soc_vault.id
}
data "azurerm_key_vault_secret" "splunk_pass4symmkey" {
  provider     = azurerm.soc
  name         = "Splunk-pass4SymmKey"
  key_vault_id = data.azurerm_key_vault.soc_vault.id
}

# Tenable Nessus
data "azurerm_key_vault_secret" "nessus_key" {
  provider     = azurerm.soc
  name         = var.nessus_key_secret
  key_vault_id = data.azurerm_key_vault.soc_vault.id
}


# Dynatrace
data "azurerm_key_vault" "cnp_vault" {
  provider            = azurerm.cnp
  name                = "infra-vault-${local.dynatrace_env}"
  resource_group_name = var.cnp_vault_rg
}
data "azurerm_key_vault_secret" "dynatrace_token" {
  provider     = azurerm.cnp
  name         = "dynatrace-${local.dynatrace_env}-token"
  key_vault_id = data.azurerm_key_vault.cnp_vault.id
}