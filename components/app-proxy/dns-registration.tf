data "azurerm_resource_group" "dns" {
  provider = azurerm.dns
  name     = "core-infra-intsvc-rg"
}

data "azurerm_private_dns_zone" "dns" {
  provider            = azurerm.dns
  name                = "platform.hmcts.net"
  resource_group_name = data.azurerm_resource_group.dns.name
}

data "azurerm_virtual_network" "dns" {
  name                = var.app_proxy_vnet_name
  resource_group_name = var.app_proxy_subnet_rg
}
resource "azurerm_private_dns_zone_virtual_network_link" "dns" {
  name                  = "App-Proxy"
  resource_group_name   = data.azurerm_resource_group.dns.name
  private_dns_zone_name = data.azurerm_private_dns_zone.dns.name
  registration_enabled  = true
  virtual_network_id    = data.azurerm_virtual_network.dns.id
}