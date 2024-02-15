module "service_accounts" {
  source        =  "terraform-google-modules/service-accounts/google"
  project_id    = "sami-islam-project101-dev"
  prefix        = var.prefix
  names         = ["single-account"]
  project_roles = ["${var.project_id}=>roles/viewer"]
  display_name  = "Single Account"
  description   = "Single Account Description"
}

output "service_accounts" {
  description = "The imported service accounts"
  value       = module.service_accounts1
}


#locals {
 # service_accounts = yamldecode(file(var.service_accounts_yaml)).service_accounts
#}

module "service_accounts1" {
  source  = "terraform-google-modules/service-accounts/google"

  for_each            = { for idx, sa in local.service_accounts : idx => sa }
  project_id          = each.value.project_id
}
