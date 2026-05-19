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
| vpc_firewall_rules | A map of firewall rules to create. | <pre>map(object({<br>  name                    = string<br>  network                 = string<br>  project                 = string<br>  description             = string<br>  direction               = string<br>  disabled                = bool<br>  priority                = number<br>  ranges                  = list(string)<br>  source_tags             = list(string)<br>  source_service_accounts = list(string)<br>  target_tags             = list(string)<br>  target_service_accounts = list(string)<br>  log_config = object({<br>    metadata = string<br>  })<br>  allow = list(object({<br>    protocol = string<br>    ports    = list(string)<br>  }))<br>  deny = list(object({<br>    protocol = string<br>    ports    = list(string)<br>  }))<br>}))</pre> | n/a | yes |

## Outputs

This module does not define any outputs.
