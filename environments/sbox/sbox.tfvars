# Build only 1 VM in SBOX for testing config
vm_count            = 1    
app_proxy_subnet_rg = "mgmt-vpn-2-sbox"
cnp_vault_rg        = "cnp-core-infra"
cnp_vault_sub       = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
dynatrace_tenant_id = "yrk32651"
dynatrace_server    = "https://10.10.70.8:9999/e/yrk32651/api"
dynatrace_hostgroup = "app-proxy-nonprod"
nessus_server       = "nessus-scanners-nonprod000005.platform.hmcts.net"
nessus_key_secret   = "nessus-agent-key-nonprod"