# Terraform AzureRM Provider Upgrade

**Upgraded**: 3.117.1 → 4.51.0 ✅  
**Date**: 6 November 2025

## What Changed

- Updated provider version to `4.51.0` in both `components/app-proxy/provider.tf` and `components/dns/provider.tf`
- Replaced `skip_provider_registration = true` with `resource_provider_registrations = "none"` in `soc` and `cnp` provider aliases

## Notes

- No breaking changes affecting current resources (azurerm_key_vault, azurerm_subnet, azurerm_dns_cname_record)
- External modules (`terraform-module-virtual-machine`, `terraform-module-common-tags`) should be tested for v4.x compatibility

## Next Steps

1. Run `terraform plan` to verify no unexpected changes

## Reference

[AzureRM v4.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide)
