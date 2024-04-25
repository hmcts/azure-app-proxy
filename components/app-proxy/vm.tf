
module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.product
  builtFrom   = var.builtFrom
}

module "shutdowntags" {
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment  = var.env
  product      = var.product
  builtFrom    = var.builtFrom
  autoShutdown = var.autoShutdown
}

resource "azurerm_resource_group" "this" {
  name     = "${var.product}-${var.env}-rg"
  location = var.location

  tags = module.tags.common_tags
}

resource "azurerm_subnet" "app_proxy" {
  name                 = "app-proxy"
  address_prefixes     = ["10.99.73.0/25"]
  resource_group_name  = var.app_proxy_subnet_rg
  virtual_network_name = var.app_proxy_vnet_name
}

locals {
  app_proxy_vm_instances = toset(["app-proxy-0", "app-proxy-1", "app-proxy-2"])
}

# TODO auto-register VMs in DNS with private dns autoregistration
module "virtual_machine" {
  providers = {
    azurerm     = azurerm
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
  }
  source   = "git::https://github.com/hmcts/terraform-module-virtual-machine.git?ref=DTSPO-17050-Upgrading-splunk-usf-version"
  for_each = local.app_proxy_vm_instances
  vm_type  = var.os_type
  # 15 Char name limit
  vm_name           = each.key
  vm_resource_group = azurerm_resource_group.this.name
  env               = var.cnp_vault_env
  vm_admin_password = azurerm_key_vault_secret.vm_admin_password.value
  vm_subnet_id      = azurerm_subnet.app_proxy.id
  vm_publisher_name = "MicrosoftWindowsServer"
  vm_offer          = "WindowsServer"
  vm_sku            = "2022-datacenter-azure-edition-core"
  vm_size           = "Standard_D2ds_v5"
  vm_version        = "latest"
  # 3 is max availability zones - round robin between them
  vm_availabilty_zones = tonumber(element(flatten(regexall("([0-9]+)$", each.key)), 0)) + 1

  # Splunk
  install_splunk_uf   = true
  splunk_username     = data.azurerm_key_vault_secret.splunk_username.value
  splunk_password     = data.azurerm_key_vault_secret.splunk_password.value
  splunk_pass4symmkey = data.azurerm_key_vault_secret.splunk_pass4symmkey.value

  # Dynatrace
  install_dynatrace_oneagent = true
  dynatrace_hostgroup        = var.dynatrace_hostgroup
  dynatrace_server           = var.dynatrace_server
  dynatrace_tenant_id        = var.dynatrace_tenant_id
  dynatrace_token            = data.azurerm_key_vault_secret.dynatrace_token.value

  # Tenable
  nessus_install = true
  nessus_server  = var.nessus_server
  nessus_key     = data.azurerm_key_vault_secret.nessus_key.value
  nessus_groups  = var.nessus_groups

  # Custom app-proxy script
  # custom_script_extension_name = "${each.value}-onboarding"
  custom_script_extension_name = "app-proxy-onboarding-0${element(flatten(regexall("([0-9]+)$", each.key)), 0)}"

  # update to point to branch
  additional_script_uri  = var.additional_script_uri
  additional_script_name = "${var.additional_script_name} -TenantId ${data.azurerm_client_config.this.tenant_id} -Username ${data.azurerm_key_vault_secret.vm_user_email.value} -Password ${data.azurerm_key_vault_secret.vm_user_password.value}"

  privateip_allocation           = "Dynamic"
  accelerated_networking_enabled = true
  tags                           = each.key == 2 ? module.shutdowntags.common_tags : module.tags.common_tags
}

data "azurerm_client_config" "this" {}
