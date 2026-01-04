locals {
  project       = "08-input-vars-locals-outputs"
  project_owner = "naivedeveloper95"
  cost_center   = "1234"
  managedBy     = "Terraform"
}

locals {
  common_tags = {
    owner         = local.project_owner
    cost_center   = local.cost_center
    managed_by    = local.managedBy
    project       = local.project
    sensitive_tag = var.my_sensitive_value
  }
}

locals {
  ec2_instance_type = var.ec2_instance_type
}
