# General
resource_group_name = "Azure-VMSS-Web-Multi-Region-MultiAZ"
location            = "uksouth"

# Storage 
storage_account_name   = "tfstatestoragemstf1"
storage_container_name = "tfstatecontainermstf1"
state_key              = "backend/terraform.tfstate"

# Environment Tags
env_tags = {
  environment = "backend"
  project     = "static-web-site"
  owner       = "backend-team"
  cost_center = "static-web-site"
}

# Backend Tags
backend_tags = {
  project_backend       = "static-web-site-backend"
  managed_by            = "terraform"
  purpose               = "terraform-state"
  cost_center_secondary = "static-web-site-backend"
  lifecycle             = "long-lived"
  criticality           = "high"
  backup_required       = "true"
}