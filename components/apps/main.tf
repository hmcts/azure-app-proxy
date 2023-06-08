provider "azuread" {}

data "azuread_client_config" "test" {}

resource "azuread_application" "test" {
  display_name = "timj-test-app2"
  owners       = [data.azuread_client_config.test.object_id]
  template_id  = "8adf8e6e-67b2-4cf2-a259-e3dc5476c621"

  on_premises_publishing {
    external_authentication_type = "aadPreAuthentication"
    internal_url = "https://contosoiwaapp.com"
    external_url = "https://contosoiwaapp-1dwnh4.msappproxy.net"
    http_only_cookie_enabled = true
    on_prem_publishing_enabled = true
    translate_host_header_enabled = true
  }

}
