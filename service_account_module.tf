module "service_accounts" {
  source        = "../.."
  project_id    = var.project_id
  prefix        = var.prefix
  names         = ["single-account"]
  project_roles = ["${var.project_id}=>roles/viewer"]
  display_name  = "Single Account"
  description   = "Single Account Description"
}
