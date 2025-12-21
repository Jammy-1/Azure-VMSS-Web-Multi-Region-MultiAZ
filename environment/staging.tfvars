# General
resource_group_name = "Azure-VMSS-Web-Multi-Region-MultiAZ"
location            = "uksouth"

tags = {
  environment = "staging"
  project     = "Web-Site"
  owner       = "dev"
}

# VMSS Tags
vmss_tags = {
  App = "vmss-static-site"
  tier = "web"
}

# VNet
vnet_name          = "vnet-static"
vnet_address_space = ["10.0.0.0/16"]
subnet_name        = "snet-web"
subnet_prefix      = "10.0.1.0/24"

public_ip_name = "pub-static-lb"

# VM
vm_size        = "Standard_B2s"
instance_count = 2
