
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
  virtual_network_name = "mgmt-vpn-2-vnet"
}

data "azurerm_key_vault" "reform_mgmt_kv" {
  name                = "ReformMgmtKeyVault"
  resource_group_name = "reformMgmtCoreRG"
}

data "azurerm_key_vault_secret" "my_secret" {
  key_vault_id = data.azurerm_key_vault.reform_mgmt_kv.id
  name         = "azure-app-proxy-vm-password"
}

# TODO auto-register VMs in DNS with private dns autoregistration
module "virtual_machine" {
  source               = "git::https://github.com/hmcts/terraform-module-virtual-machine.git?ref=DTSPO-14061-bootstrap-changes"
  count                = 3
  vm_type              = var.os_type
  vm_name              = "${var.product}-${var.env}-${count.index}"
  vm_resource_group    = azurerm_resource_group.this.name
  vm_admin_password    = data.azurerm_key_vault_secret.my_secret.value
  vm_subnet_id         = azurerm_subnet.app_proxy_subnet.id
  vm_publisher_name    = var.vm_publisher_name
  vm_offer             = var.vm_offer
  vm_sku               = var.vm_sku
  vm_size              = var.vm_size
  vm_version           = var.vm_version
  vm_availabilty_zones = var.vm_availabilty_zones
  // Required to pass custom script to terraform-module-vm-bootstrap
  install_app_proxy            = true
  custom_script_extension_name = "app-proxy-onboarding-${count.index}"
  additional_script_uri        = var.script_url
  additional_script_name       = var.additional_script_name

  privateip_allocation           = "Dynamic"
  accelerated_networking_enabled = true
  tags                           = module.tags.common_tags
}

data "azurerm_client_config" "this" {}

