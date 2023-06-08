// TODO read from yaml config
// TODO do we want to sync these to private DNS or use split brain DNS?
resource "azurerm_dns_cname_record" "this" {
  name                = "my-test-app.app-proxy-poc"
  resource_group_name = "reformmgmtrg"
  record              = "my-test-app-1dwnh4.msappproxy.net"
  ttl                 = 3600
  zone_name           = "sandbox.platform.hmcts.net"
}