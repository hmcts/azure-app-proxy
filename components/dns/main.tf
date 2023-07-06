data "local_file" "configuration" {
  filename = "${path.cwd}/../../apps.yaml"
}

locals {
  apps = yamldecode(data.local_file.configuration.content).apps
  cname_records = flatten([
    for app in local.apps : split(".", replace("${app.externalUrl}", "https://", ""))[0]
  ])
}


resource "azurerm_dns_cname_record" "this" {
  for_each = toset(local.cname_records)

  name                = each.value
  zone_name           = "hmcts.net"
  resource_group_name = "reformmgmtrg"
  ttl                 = 3600
  record              = "${each.value}-cjscommonplatform.msappproxy.net"
}