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
| [google_compute_network_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy) | resource |
| [google_compute_network_firewall_policy_association.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_association) | resource |
| [google_compute_network_firewall_policy_rule.rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_association_targets"></a> [association\_targets](#input\_association\_targets) | (Required) The target that the firewall policy is attached to. | `map(string)` | `{}` | no |
| <a name="input_nw_fw_policy_description"></a> [nw\_fw\_policy\_description](#input\_nw\_fw\_policy\_description) | An optional description of this resource. Provide this property when you create the resource. | `string` | n/a | yes |
| <a name="input_nw_fw_policy_name"></a> [nw\_fw\_policy\_name](#input\_nw\_fw\_policy\_name) | (Required) User-provided name of the Network firewall policy. The name should be unique in the project in which the firewall policy is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_nw_fw_policy_project"></a> [nw\_fw\_policy\_project](#input\_nw\_fw\_policy\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_nw_fw_policy_rules"></a> [nw\_fw\_policy\_rules](#input\_nw\_fw\_policy\_rules) | n/a | <pre>map(object({<br/>    action    = string // (Required) The Action to perform when the client connection triggers the rule. Valid actions are "allow", "deny", "goto_next" and "apply_security_profile_group".<br/>    direction = string // (Required) The direction in which this rule applies. Possible values: INGRESS, EGRESS<br/>    # priority                = number                 // (Required) An integer indicating the priority of a rule in the list. The priority must be a positive value between 0 and 2147483647. Rules are evaluated from highest to lowest priority where 0 is the highest priority and 2147483647 is the lowest prority.<br/>    # project                 = string                 // The project for the resource<br/>    description    = string // An optional description for this resource.<br/>    disabled       = bool   // Denotes whether the firewall policy rule is disabled. When set to true, the firewall policy rule is not enforced and traffic behaves as if it did not exist. If this is unspecified, the firewall policy rule will be enabled.<br/>    enable_logging = bool   // Denotes whether to enable logging for a particular rule. If logging is enabled, logs will be exported to the configured export destination in Stackdriver. Logs may be exported to BigQuery or Pub/Sub. Note: you cannot enable logging on "goto_next" rules.<br/>    # rule_name               = string                 // An optional name for the rule. This field is not a unique identifier and can be updated.<br/>    security_profile_group  = string                 // A fully-qualified URL of a SecurityProfileGroup resource. Example: https://networksecurity.googleapis.com/v1/organizations/{organizationId}/locations/global/securityProfileGroups/my-security-profile-group. It must be specified if action = 'apply_security_profile_group' and cannot be specified for other actions.<br/>    target_service_accounts = list(string)           // A list of service accounts indicating the sets of instances that are applied with this rule.<br/>    tls_inspect             = bool                   // Boolean flag indicating if the traffic should be TLS decrypted. It can be set only if action = 'apply_security_profile_group' and cannot be set for other actions.<br/>    target_secure_tags      = optional(list(string)) // A list of secure tags that controls which instances the firewall rule applies to. If are specified, then the firewall rule applies only to instances in the VPC network that have one of those EFFECTIVE secure tags, if all the target_secure_tag are in INEFFECTIVE state, then this rule will be ignored. may not be set at the same time as . If neither nor are specified, the firewall rule applies to all instances on the specified network. Maximum number of target label tags allowed is 256.<br/>    match = object({<br/>      src_ip_ranges             = optional(list(string), []) // CIDR IP address range. Maximum number of source CIDR IP ranges allowed is 5000.<br/>      src_fqdns                 = optional(list(string), []) // Domain names that will be used to match against the resolved domain name of source of traffic. Can only be specified if DIRECTION is ingress.<br/>      src_region_codes          = optional(list(string), []) // The Unicode country codes whose IP addresses will be used to match against the source of traffic. Can only be specified if DIRECTION is ingress.<br/>      src_threat_intelligences  = optional(list(string), []) // Name of the Google Cloud Threat Intelligence list.<br/>      src_address_groups        = optional(list(string), []) // Address groups which should be matched against the traffic source. Maximum number of source address groups is 10. Source address groups is only supported in Ingress rules.<br/>      dest_ip_ranges            = optional(list(string), []) // CIDR IP address range. Maximum number of destination CIDR IP ranges allowed is 5000.<br/>      dest_fqdns                = optional(list(string), []) // Domain names that will be used to match against the resolved domain name of destination of traffic. Can only be specified if DIRECTION is egress.<br/>      dest_region_codes         = optional(list(string), []) // The Unicode country codes whose IP addresses will be used to match against the source of traffic. Can only be specified if DIRECTION is egress.<br/>      dest_threat_intelligences = optional(list(string), []) // Name of the Google Cloud Threat Intelligence list.<br/>      dest_address_groups       = optional(list(string), []) // Address groups which should be matched against the traffic destination. Maximum number of destination address groups is 10. Destination address groups is only supported in Egress rules.<br/>      src_secure_tags           = optional(list(string), []) // List of secure tag values, which should be matched at the source of the traffic. For INGRESS rule, if all the are INEFFECTIVE, and there is no , this rule will be ignored. Maximum number of source tag values allowed is 256.<br/>      layer4_configs = map(object({<br/>        ip_protocol = string       // The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, ipip, sctp), or the IP protocol number.<br/>        ports       = list(string) // An optional list of ports to which this rule applies. This field is only applicable for UDP or TCP protocol. Each entry must be either an integer or a range. If not specified, this rule applies to connections through any port. Example inputs include: ``.<br/>      }))<br/>    })<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
