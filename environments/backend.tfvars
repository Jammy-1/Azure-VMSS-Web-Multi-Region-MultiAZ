resource_group_name = "Azure-VMSS-Web-Multi-Region-MultiAZ"
location            = "uksouth"

storage_account_name   = "tfstatestoragemstf1"
storage_container_name = "tfstatecontainermstf1"
state_key              = "production/terraform.tfstate"

tags = {
  environment = "prod"
  project     = "static-site-public"
  owner       = "devops-team"
}