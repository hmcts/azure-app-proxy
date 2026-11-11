resource "azurerm_key_vault_access_policy" "management_wif" {
  key_vault_id = azurerm_key_vault.app_proxy_kv.id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = "ab4e3b65-cc4c-4819-8a4c-47618bce543d"

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
  ]
}
