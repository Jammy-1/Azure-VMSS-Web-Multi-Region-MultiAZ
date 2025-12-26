resource_group_name = "Azure-VMSS-Web-Multi-Region-MultiAZ"
location            = "uksouth"

storage_account_name   = "tfstatestorage"
storage_container_name = "tfstatecontainer"
state_key              = "production/terraform.tfstate"

tags = {
  environment = "prod"
  project     = "static-site-public"
  owner       = "devops-team"
}