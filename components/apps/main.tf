provider "azurerm" {
  features {}
}

// TODO add DNS records here

resource "azurerm_dns_cname_record" "this" {
  name                = ""
  resource_group_name = ""
  ttl                 = 0
  zone_name           = ""
}