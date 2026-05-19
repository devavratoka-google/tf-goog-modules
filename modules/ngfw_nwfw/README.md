# Network Firewall Policy (NGFW NWFW) Module

This module creates a Google Cloud Compute Global Network Firewall Policy, registers associations between the policy and target VPC networks, and creates firewall rules associated with the policy.

## Usage

```hcl
module "network_firewall" {
  source                  = "./modules/ngfw_nwfw"
  nw_fw_policy_name       = "my-network-firewall-policy"
  nw_fw_policy_description = "Global network-level firewall policy"
  nw_fw_policy_project     = "my-project-id"

  association_targets = {
    "my-vpc" = "projects/my-project-id/global/networks/my-vpc"
  }

  nw_fw_policy_rules = {
    "1000" = {
      action         = "allow"
      direction      = "INGRESS"
      description    = "Allow internal HTTP traffic"
      disabled       = false
      enable_logging = true
      
      security_profile_group  = null
      target_service_accounts = []
      tls_inspect             = false
      target_secure_tags      = []
      
      match = {
        src_ip_ranges  = ["10.0.0.0/8"]
        layer4_configs = {
          "tcp-80" = {
            ip_protocol = "tcp"
            ports       = ["80"]
          }
        }
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
| nw_fw_policy_name | User-provided name of the Network firewall policy. | `string` | n/a | yes |
| nw_fw_policy_description | An optional description of this resource. | `string` | n/a | yes |
| nw_fw_policy_project | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| association_targets | The target VPC network paths that the firewall policy is attached to. | `map(string)` | `{}` | no |
| nw_fw_policy_rules | Map where the key is the rule priority and value contains the rule configuration. | <pre>map(object({<br>  action                  = string<br>  direction               = string<br>  description             = string<br>  disabled                = bool<br>  enable_logging          = bool<br>  security_profile_group  = string<br>  target_service_accounts = list(string)<br>  tls_inspect             = bool<br>  target_secure_tags      = optional(list(string))<br>  match = object({<br>    src_ip_ranges             = optional(list(string), [])<br>    src_fqdns                 = optional(list(string), [])<br>    src_region_codes          = optional(list(string), [])<br>    src_threat_intelligences  = optional(list(string), [])<br>    src_address_groups        = optional(list(string), [])<br>    dest_ip_ranges            = optional(list(string), [])<br>    dest_fqdns                = optional(list(string), [])<br>    dest_region_codes         = optional(list(string), [])<br>    dest_threat_intelligences = optional(list(string), [])<br>    dest_address_groups       = optional(list(string), [])<br>    src_secure_tags           = optional(list(string), [])<br>    layer4_configs = map(object({<br>      ip_protocol = string<br>      ports       = list(string)<br>    }))<br>  })<br>}))</pre> | n/a | yes |

## Outputs

This module does not define any outputs.
