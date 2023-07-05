variable "env" {}
variable "product" {}
variable "builtFrom" {}
variable "location" {
  default = "uksouth"
}

# VM Configuration Block
variable "os_type" {
  default     = "windows"
  description = "VM OS type, defaults to windows for app_proxy resources."
  type        = string
}
variable "additional_script_uri" {
  default     = "https://raw.githubusercontent.com/hmcts/azure-app-proxy/DTSPO-14061-Add-vms/components/app-proxy/Bootstrap-Application-Proxy.ps1"
  description = "URI of a publically accessible script to run against the virtual machine."
}
variable "additional_script_name" {
  default = "Bootstrap-Application-Proxy.ps1"
}
variable "app_proxy_subnet_rg" {
  default = "mgmt-vpn-2-mgmt"
}
variable "app_proxy_vnet_name" {
  default = "mgmt-vpn-2-vnet"
}
variable "vm_count" {
  default = 3
}

variable "dynatrace_tenant_id" {}
variable "dynatrace_hostgroup" {}
variable "dynatrace_server" {}

# Nessus
variable "install_nessus" {
  default = true
}
variable "nessus_server" {}
variable "nessus_key_secret" {}
variable "nessus_groups" {
  default = "Platform-Operations-App-Proxy"
}

variable "cnp_vault_sub" {}
variable "cnp_vault_rg" {}

