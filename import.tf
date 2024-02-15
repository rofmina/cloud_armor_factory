variable "service_accounts_yaml" {
  description = "Path to the YAML file containing service accounts"
  default     = "service_accounts.yaml"
}

locals {
  service_accounts = yamldecode(file(var.service_accounts_yaml)).service_accounts
}

resource "null_resource" "import_service_accounts" {
  count = length(local.service_accounts)

  triggers = {
    email          = local.service_accounts[count.index].name
    source_project = local.service_accounts[count.index].source_project
  }

  provisioner "local-exec" {
    command = "terraform import google_service_account.example ${local.service_accounts[count.index].name}"
  }
}
