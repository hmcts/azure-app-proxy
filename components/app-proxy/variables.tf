variable "env" {}
variable "product" {}
variable "builtFrom" {}
variable "location" {
  default = "uksouth"
}
variable "os_type" {
  default     = "windows"
  description = "VM OS type, defaults to windows for app_proxy resources."
  type        = string
}
variable "script_url" {
  default     = "https://raw.githubusercontent.com/hmcts/azure-app-proxy/HEAD/components/app-proxy/Bootstrap-Application-Proxy.ps1"
  description = "URI of a publically accessible script to run against the virtual machine."
}
variable "vm_publisher_name" {
  default = "MicrosoftWindowsServer"
}

variable "vm_offer" {
  default = "WindowsServer"
}

variable "vm_sku" {
  default = "2022-datacenter-azure-edition-core"
}

variable "vm_size" {
  default = "Standard_D2ds_v5"
}

variable "vm_version" {
  default = "latest"
}

variable "vm_availabilty_zones" {
  default = "1"
}

variable "additional_script_name" {
  default = "bootstrap_application_proxy.ps1"
}

variable "app_proxy_subnet_rg" {
  default = "mgmt-vpn-2-mgmt"
}