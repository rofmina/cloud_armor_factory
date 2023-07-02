output "pre_configured_rules" {
    value=local.cloud_armor_policies
    
}
output "policy" {
    value=local.central_policy
}