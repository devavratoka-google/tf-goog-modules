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

## Requirements

| Name | Version |
|------|---------|
| terraform | > 1.5.0 |
| google | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent | The parent of the firewall policy (e.g. `organizations/{organization_id}`). | `string` | n/a | yes |
| short_name | User-provided name of the Organization firewall policy. | `string` | n/a | yes |
| description | An optional description of this resource. | `string` | n/a | yes |
| fw_policy_associations | The list of firewall policy associations. | <pre>map(object({<br>  attachment_target = string<br>  association_name  = string<br>}))</pre> | n/a | yes |
| fw_policy_rules | List of Ingress/Egress rules | <pre>map(object({<br>  priority                = number<br>  direction               = string<br>  action                  = string<br>  rule_name               = optional(string)<br>  disabled                = optional(bool)<br>  description             = optional(string)<br>  enable_logging          = optional(bool)<br>  target_service_accounts = optional(list(string), [])<br>  target_resources        = optional(list(string), [])<br>  security_profile_group  = optional(string, null)<br>  tls_inspect             = optional(bool, false)<br>  target_secure_tags      = optional(list(string), [])<br>  match = object({<br>    src_ip_ranges             = optional(list(string), [])<br>    src_fqdns                 = optional(list(string), [])<br>    src_region_codes          = optional(list(string), [])<br>    src_threat_intelligences  = optional(list(string), [])<br>    src_address_groups        = optional(list(string), [])<br>    dest_ip_ranges            = optional(list(string), [])<br>    dest_fqdns                = optional(list(string), [])<br>    dest_region_codes         = optional(list(string), [])<br>    dest_threat_intelligences = optional(list(string), [])<br>    dest_address_groups       = optional(list(string), [])<br>    src_secure_tags           = optional(list(string), [])<br>    layer4_configs = optional(list(object({<br>      ip_protocol = string<br>      ports       = optional(list(string), [])<br>    })))<br>  })<br>}))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| hfw_id | The ID of the created firewall policy |
| hfw_policy_id | The firewall policy ID |
| hfw_selflink_id | The self_link with ID of the created firewall policy |
