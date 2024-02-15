module "service_accounts" {
  source        =  "terraform-google-modules/service-accounts/google"
  project_id    = "sami-islam-project101-dev"
  prefix        = var.prefix
  names         = ["single-account"]
  project_roles = ["${var.project_id}=>roles/viewer"]
  display_name  = "Single Account"
  description   = "Single Account Description"
}
variable "service_accounts_yaml" {
  description = "Path to the YAML file containing service accounts"
}
output "service_accounts" {
  description = "The imported service accounts"
  value       = module.service_accounts1
}

variable "service_accounts_yaml" {
  description = "Path to the YAML file containing service accounts"
}

locals {
  service_accounts = yamldecode(file(var.service_accounts_yaml)).service_accounts
}

module "service_accounts1" {
  source  = "terraform-google-modules/service-accounts/google"

  for_each            = { for idx, sa in local.service_accounts : idx => sa }

  account_id          = each.value.name
  project_id          = each.value.project_id
