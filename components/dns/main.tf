data "local_file" "configuration" {
  filename = "${path.cwd}/../../apps.yaml"
}

locals {
  apps = yamldecode(data.local_file.configuration.content).apps
  cname_records = flatten([
    for app in local.apps : {
      name = split(".", replace("${app.externalUrl}", "https://", ""))[0],
      # Splits externalUrl by dot and slices the first item in the list, joins them back with dot to form the domain name.
      zone_name = join(".", slice(split(".", "${app.externalUrl}"), 1, length(split(".", "${app.externalUrl}"))))
    }
  ])
}


resource "azurerm_dns_cname_record" "this" {
  for_each = { for record in local.cname_records : record.name => record }

  name                = each.value.name
  zone_name           = each.value.zone_name
  resource_group_name = "reformmgmtrg"
  ttl                 = 3600
  record              = "${each.value.name}-cjscommonplatform.msappproxy.net"
}
