# VPC Firewall Module

This module configures traditional Google Compute Engine VPC firewall rules.

## Usage

```hcl
module "vpc_firewall" {
  source = "./modules/vpc_firewall"

  vpc_firewall_rules = {
    "allow-ssh" = {
      name                    = "allow-ssh-ingress"
      network                 = "my-vpc-self-link"
      project                 = "my-project-id"
      description             = "Allow SSH ingress from specific range"
      direction               = "INGRESS"
      disabled                = false
      priority                = 1000
      ranges                  = ["203.0.113.0/24"]
      source_tags             = []
      source_service_accounts = []
      target_tags             = ["ssh-enabled"]
      target_service_accounts = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      deny = []
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
| [google_compute_firewall.rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_firewall_rules"></a> [vpc\_firewall\_rules](#input\_vpc\_firewall\_rules) | n/a | <pre>map(object({<br/>    name                    = string<br/>    network                 = string<br/>    project                 = string<br/>    description             = string<br/>    direction               = string<br/>    disabled                = bool<br/>    priority                = number<br/>    ranges                  = list(string)<br/>    source_tags             = list(string)<br/>    source_service_accounts = list(string)<br/>    target_tags             = list(string)<br/>    target_service_accounts = list(string)<br/>    log_config = object({<br/>      metadata = string<br/>    })<br/>    allow = list(object({<br/>      protocol = string<br/>      ports    = list(string)<br/>    }))<br/>    deny = list(object({<br/>      protocol = string<br/>      ports    = list(string)<br/>    }))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_rules"></a> [firewall\_rules](#output\_firewall\_rules) | The created firewall rule resources. |
<!-- END_TF_DOCS -->
