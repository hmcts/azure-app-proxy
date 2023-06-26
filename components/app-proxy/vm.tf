
module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.product
  builtFrom   = var.builtFrom
}


resource "azurerm_resource_group" "this" {
  name     = "${var.product}-${var.env}-rg"
  location = var.location

  tags = module.tags.common_tags
}

resource "azurerm_subnet" "app_proxy_subnet" {
  name                 = "app-proxy"
  address_prefixes     = ["10.99.73.0/25"]
  resource_group_name  = var.app_proxy_subnet_rg
  virtual_network_name = var.app_proxy_subnet_name
}

data "azurerm_key_vault" "reform_mgmt_kv" {
  name                = "ReformMgmtKeyVault"
  resource_group_name = "reformMgmtCoreRG"
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  key_vault_id = data.azurerm_key_vault.reform_mgmt_kv.id
  name         = "azure-app-proxy-vm-password"
}

# TODO auto-register VMs in DNS with private dns autoregistration
module "virtual_machine" {
  source  = "git::https://github.com/hmcts/terraform-module-virtual-machine.git?ref=master"
  count   = var.vm_count
  vm_type = var.os_type
  # 15 Char name limit
  vm_name              = "${var.product}-${count.index}"
  vm_resource_group    = azurerm_resource_group.this.name
  vm_admin_password    = data.azurerm_key_vault_secret.vm_admin_password.value
  vm_subnet_id         = azurerm_subnet.app_proxy_subnet.id
  vm_publisher_name    = var.vm_publisher_name
  vm_offer             = var.vm_offer
  vm_sku               = var.vm_sku
  vm_size              = var.vm_size
  vm_version           = var.vm_version
  vm_availabilty_zones = var.vm_availabilty_zones

  # Splunk
  install_splunk_uf   = var.install_splunk_uf
  splunk_username     = data.azurerm_key_vault_secret.splunk_username.value
  splunk_password     = data.azurerm_key_vault_secret.splunk_password.value
  splunk_pass4symmkey = data.azurerm_key_vault_secret.splunk_pass4symmkey.value

  # Dynatrace
  install_dynatrace_oneagent = var.install_dynatrace_oa
  dynatrace_hostgroup        = var.dynatrace_hostgroup
  dynatrace_server           = var.dynatrace_server
  dynatrace_tenant_id        = var.dynatrace_tenant_id
  dynatrace_token            = data.azurerm_key_vault_secret.token.value

  # Tenable
  nessus_install = true
  nessus_server  = var.nessus_server
  nessus_key     = data.azurerm_key_vault_secret.nessus_key.value
  nessus_groups  = var.nessus_groups

  # Custom app-proxy script
  custom_script_extension_name = "app-proxy-onboarding-0${count.index}"
  additional_script_uri        = var.additional_script_uri
  additional_script_name       = "${var.additional_script_name} -TenantId ${data.azurerm_client_config.this.tenant_id} -Token ${var.user_token}"

  privateip_allocation           = "Dynamic"
  accelerated_networking_enabled = true
  tags                           = module.tags.common_tags
}

data "azurerm_client_config" "this" {}

# data "external" "this" {
#   program = ["bash", "${path.module}/get-access-token.sh"]
# }
