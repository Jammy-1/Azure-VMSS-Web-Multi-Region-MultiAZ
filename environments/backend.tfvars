resource_group_name = "Azure-VMSS-Web-Multi-Region-MultiAZ"
location            = "uksouth"

storage_account_name = "tfstatestorage"
container_name       = "tfstatecontainer"
key                  = "production/terraform.tfstate"

tags = {
  environment = "prod"
  project     = "static-site-public"
  owner       = "devops-team"
}