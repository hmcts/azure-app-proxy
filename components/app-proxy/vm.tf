
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

# TODO store in a vault
resource "random_password" "this" {
  length = 30
}

resource "azurerm_subnet" "this" {
  name                 = "app-proxy"

  address_prefixes     = ["10.99.73.0/25"]
  resource_group_name  = "mgmt-vpn-2-mgmt"
  virtual_network_name = "mgmt-vpn-2-vnet"
}

# TODO auto-register VMs in DNS with private dns autoregistration
module "virtual_machine" {
  source               = "git::https://github.com/hmcts/terraform-module-virtual-machine.git?ref=master"

  vm_type              = "windows"
  vm_name              = "${var.product}-${var.env}"
  vm_resource_group    = azurerm_resource_group.this.name
  vm_admin_password    = random_password.this.result
  vm_subnet_id         = azurerm_subnet.this.id
  vm_publisher_name    = "MicrosoftWindowsServer"
  vm_offer             = "WindowsServer"
  vm_sku               = "2022-datacenter-azure-edition-core"
  vm_size              = "Standard_D2ds_v5"
  vm_version           = "latest"
  vm_availabilty_zones = "1"

  privateip_allocation = "Dynamic"

  accelerated_networking_enabled = true
  tags                 = module.tags.common_tags
}

# TODO remove and store in a vault
output "vm_password" {
  value = random_password.this.result
  sensitive = true
}
