moved {
  from = module.virtual_machine[0].azurerm_network_interface.vm_nic
  to   = module.virtual_machine["app-proxy-0"].azurerm_network_interface.vm_nic
}

moved {
  from = module.virtual_machine[0].azurerm_windows_virtual_machine.winvm[0]
  to   = module.virtual_machine["app-proxy-0"].azurerm_windows_virtual_machine.winvm[0]
}

moved {
  from = module.virtual_machine[1].azurerm_network_interface.vm_nic
  to   = module.virtual_machine["app-proxy-1"].azurerm_network_interface.vm_nic
}

moved {
  from = module.virtual_machine[1].azurerm_windows_virtual_machine.winvm[0]
  to   = module.virtual_machine["app-proxy-1"].azurerm_windows_virtual_machine.winvm[0]
}

moved {
  from = module.virtual_machine[2].azurerm_network_interface.vm_nic
  to   = module.virtual_machine["app-proxy-2"].azurerm_network_interface.vm_nic
}

moved {
  from = module.virtual_machine[2].azurerm_windows_virtual_machine.winvm[0]
  to   = module.virtual_machine["app-proxy-2"].azurerm_windows_virtual_machine.winvm[0]
}

moved {
  from = module.virtual_machine[0].module.vm-bootstrap[0].azurerm_virtual_machine_extension.azure_monitor[0]
  to   = module.virtual_machine["app-proxy-0"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.azure_monitor[0]
}

moved {
  from = module.virtual_machine[0].module.vm-bootstrap[0].azurerm_virtual_machine_extension.custom_script[0]
  to   = module.virtual_machine["app-proxy-0"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.custom_script[0]
}

moved {
  from = module.virtual_machine[0].module.vm-bootstrap[0].azurerm_virtual_machine_extension.dynatrace_oneagent[0]
  to   = module.virtual_machine["app-proxy-0"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.dynatrace_oneagent[0]
}

moved {
  from = module.virtual_machine[0].module.vm-bootstrap[0].azurerm_virtual_machine_extension.endpoint_protection[0]
  to   = module.virtual_machine["app-proxy-0"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.endpoint_protection[0]
}

# moved {
#   from = module.virtual_machine[1].module.vm-bootstrap[0].azurerm_virtual_machine_extension.azure_monitor[0]
#   to   = module.virtual_machine["app-proxy-1"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.azure_monitor[0]
# }

# moved {
#   from = module.virtual_machine[1].module.vm-bootstrap[0].azurerm_virtual_machine_extension.custom_script[0]
#   to   = module.virtual_machine["app-proxy-1"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.custom_script[0]
# }

# moved {
#   from = module.virtual_machine[1].module.vm-bootstrap[0].azurerm_virtual_machine_extension.dynatrace_oneagent[0]
#   to   = module.virtual_machine["app-proxy-1"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.dynatrace_oneagent[0]
# }

# moved {
#   from = module.virtual_machine[1].module.vm-bootstrap[0].azurerm_virtual_machine_extension.endpoint_protection[0]
#   to   = module.virtual_machine["app-proxy-1"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.endpoint_protection[0]
# }

moved {
  from = module.virtual_machine[2].module.vm-bootstrap[0].azurerm_virtual_machine_extension.azure_monitor[0]
  to   = module.virtual_machine["app-proxy-2"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.azure_monitor[0]
}

moved {
  from = module.virtual_machine[2].module.vm-bootstrap[0].azurerm_virtual_machine_extension.custom_script[0]
  to   = module.virtual_machine["app-proxy-2"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.custom_script[0]
}

moved {
  from = module.virtual_machine[2].module.vm-bootstrap[0].azurerm_virtual_machine_extension.dynatrace_oneagent[0]
  to   = module.virtual_machine["app-proxy-2"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.dynatrace_oneagent[0]
}

moved {
  from = module.virtual_machine[2].module.vm-bootstrap[0].azurerm_virtual_machine_extension.endpoint_protection[0]
  to   = module.virtual_machine["app-proxy-2"].module.vm-bootstrap[0].azurerm_virtual_machine_extension.endpoint_protection[0]
}













