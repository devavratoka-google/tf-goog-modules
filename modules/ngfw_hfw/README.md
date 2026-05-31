# Hierarchical Firewall Policy (NGFW HFW) Module

This module configures a Google Compute Hierarchical Firewall Policy, associations with resources (like organizations or folders), and standard firewall rules inside the policy.

## Usage

```hcl
module "hierarchical_firewall" {
  source      = "./modules/ngfw_hfw"
  parent      = "organizations/1234567890"
  short_name  = "my-hierarchical-policy"
  description = "Organization-level hierarchical firewall policy"

  fw_policy_associations = {
    "folder-association" = {
      attachment_target = "folders/987654321"
      association_name  = "assoc-folder-987654321"
    }
  }

  fw_policy_rules = {
    "allow-internal" = {
      priority    = 1000
      direction   = "INGRESS"
      action      = "allow"
      rule_name   = "allow-internal-traffic"
      disabled    = false
      description = "Allow internal IP ranges"
      match = {
        src_ip_ranges = ["10.0.0.0/8"]
        layer4_configs = [
          {
            ip_protocol = "all"
          }
        ]
      }
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall_policy) | resource |
| [google_compute_firewall_policy_association.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall_policy_association) | resource |
| [google_compute_firewall_policy_rule.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall_policy_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. Provide this property when you create the resource. | `string` | n/a | yes |
| <a name="input_fw_policy_associations"></a> [fw\_policy\_associations](#input\_fw\_policy\_associations) | The list of firewall policy associations. | <pre>map(object({<br/>    attachment_target = string<br/>    association_name  = string<br/>  }))</pre> | n/a | yes |
| <a name="input_fw_policy_rules"></a> [fw\_policy\_rules](#input\_fw\_policy\_rules) | List of Ingress/Egress rules | <pre>map(object({<br/>    priority                = number<br/>    direction               = string<br/>    action                  = string // "allow", "deny", "goto_next" and "apply_security_profile_group"<br/>    rule_name               = optional(string)<br/>    disabled                = optional(bool)<br/>    description             = optional(string)<br/>    enable_logging          = optional(bool)<br/>    target_service_accounts = optional(list(string), [])<br/>    target_resources        = optional(list(string), [])<br/>    security_profile_group  = optional(string, null)<br/>    tls_inspect             = optional(bool, false)<br/>    target_secure_tags      = optional(list(string), [])<br/>    match = object({<br/>      src_ip_ranges             = optional(list(string), [])<br/>      src_fqdns                 = optional(list(string), [])<br/>      src_region_codes          = optional(list(string), [])<br/>      src_threat_intelligences  = optional(list(string), [])<br/>      src_address_groups        = optional(list(string), [])<br/>      dest_ip_ranges            = optional(list(string), [])<br/>      dest_fqdns                = optional(list(string), [])<br/>      dest_region_codes         = optional(list(string), [])<br/>      dest_threat_intelligences = optional(list(string), [])<br/>      dest_address_groups       = optional(list(string), [])<br/>      src_secure_tags           = optional(list(string), [])<br/>      layer4_configs = optional(list(object({<br/>        ip_protocol = string<br/>        ports       = optional(list(string), [])<br/>        }))<br/>      )<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_parent"></a> [parent](#input\_parent) | (Required) The parent of the firewall policy. | `string` | n/a | yes |
| <a name="input_short_name"></a> [short\_name](#input\_short\_name) | (Required) User-provided name of the Organization firewall policy. The name should be unique in the organization in which the firewall policy is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hfw_id"></a> [hfw\_id](#output\_hfw\_id) | n/a |
| <a name="output_hfw_policy_id"></a> [hfw\_policy\_id](#output\_hfw\_policy\_id) | n/a |
| <a name="output_hfw_selflink_id"></a> [hfw\_selflink\_id](#output\_hfw\_selflink\_id) | n/a |
<!-- END_TF_DOCS -->
