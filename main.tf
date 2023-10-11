locals {
  cloud_armor_policies = [for f in fileset("${path.module}/cloudarmorconfigs", "[^_]*.yaml") : yamldecode(file("${path.module}/cloudarmorconfigs/${f}"))]
  cloud_armor_list = flatten([
    for cloud_armor_policy in local.cloud_armor_policies : [
      for policy in try(cloud_armor_policy.central_policy, []) : {
        name               = policy.name
        project_id         = policy.project_id
        description        = try(policy.description, [])
        default_rule_action= try(policy.default_rule_action, [])  
        type               = try(policy.type, [])
        json_parsing       = try(policy.json_parsing, [])
        layer_7_ddos_defense_enable = try(policy.layer_7_ddos_defense_enable, [])
        layer_7_ddos_defense_rule_visibility = try(policy.layer_7_ddos_defense_rule_visibility, [])
        default_rule_action          = try(policy.default_rule_action,[])
        pre_configured_rules = try(policy.pre_configured_rules,[])
      }
    ]
  ])
}


module "cloud_armor" {
  source = "./modules/cloud-armor"
  for_each     = { for policy in local.cloud_armor_list : "${policy.name}-${policy.project_id}" => policy }
  project_id = each.value.project_id
  name = each.value.name
  description = each.value.description
  json_parsing = each.value.json_parsing #"STANDARD"
  #Enable Adaptive Protection
  layer_7_ddos_defense_enable = each.value.layer_7_ddos_defense_enable #true
  layer_7_ddos_defense_rule_visibility = each.value.layer_7_ddos_defense_rule_visibility #"STANDARD"

  default_rule_action          = each.value.default_rule_action #"deny(404)"
  #Add pre-configured rules
  #Set target to lb backend
  pre_configured_rules = each.value.pre_configured_rules
}
#example of cloud armor factory
