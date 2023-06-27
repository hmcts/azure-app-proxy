resource "azurerm_key_vault" "app_proxy_kv" {
  name                = "${var.product}-kv"
  location            = "UK South"
  resource_group_name = azurerm_resource_group.app_proxy_rg.name
  tenant_id           = data.azurerm_client_config.this.tenant_id
  sku_name            = "standard"
}

resource "random_password" "this" {
  length = 30
}

resource "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  value        = random_password.this.result
  key_vault_id = azurerm_key_vault.app_proxy_kv.id
}

data "azurerm_key_vault_secret" "vm_user_email" {
  key_vault_id = azurerm_key_vault.app_proxy_kv.id
  name         = "azure-app-proxy-user-email"
}

data "azurerm_key_vault_secret" "vm_user_password" {
  key_vault_id = azurerm_key_vault.app_proxy_kv.id
  name         = "azure-app-proxy-user-password"
}
