variable "service_account_latest_yaml" {
  description = "Path to the YAML file containing service accounts"
}

locals {
  service_accounts_latest = yamldecode(file(var.service_account_latest_yaml))
}

resource "null_resource" "import_service_accounts_latest" {
  for_each = local.service_accounts_latest

  triggers = {
    source_project = each.value.source_project
  }

  provisioner "local-exec" {
    command = "terraform import module.service-account[\"${each.key}-${each.value.source_project}\"].google_service_account.service_account[0] projects/${each.value.source_project}/serviceAccounts/${each.key}"
  }
}
