data "azurerm_key_vault" "certificate_vault" {
  name                = "acmedtscftptlintsvc"
  resource_group_name = "cft-platform-ptl-rg"
  provider            = azurerm.cftptl
}

resource "azurerm_role_assignment" "vault_access" {
  role_definition_name = "Key Vault Secrets User"
  principal_id         = "626041d7-1bf3-46ca-84b6-28b6b0c60efe" # DTS Operations Bootstrap GA
  scope                = data.azurerm_key_vault.certificate_vault.id
}
