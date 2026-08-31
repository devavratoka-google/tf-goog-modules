# DNS Zone tfvars Generator

This helper script automates creating a Terraform `.tfvars` DNS zone entry from a standard GCP project name matching the naming convention:
`cx-<env>-<function>-<sdlc>-<suffix>`

## Usage

Run the script by passing one or more GCP project names as command-line arguments:

```bash
python3 modules/dns_generator/generate.py <gcp-project-name-1> [gcp-project-name-2] ...
```

### Example

```bash
python3 modules/dns_generator/generate.py cx-pr-abcd-dev-01 cx-pr-agentgw-dev-01
```

**Output:**
```hcl
dns_zones = {
  "abcd" : {
    dns_name    = "abcd.dev.gcpinternal.cxname.com."
    description = "Private zone for abcd.dev.gcpinternal.cxname.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project     = "cx-pr-abcd-dev-01"
    record_sets = {}
  },
  "peering-abcd-dev-gcpinternal-cxname-com" : {
    dns_name    = "abcd.dev.gcpinternal.cxname.com."
    description = "DNS Peering zone for abcd.dev.gcpinternal.cxname.com."
    visibility  = "private"
    networks    = ["vpc-g-ssvcs-transit"]
    project     = "cx-pr-ssvcs-transit-nw-01"
    peering_config = {
      target_network = "https://www.googleapis.com/compute/v1/projects/cx-pr-infra-nw-dev-01/global/networks/vpc-name"
    }
  },
  "agentgw" : {
    dns_name    = "agentgw.dev.gcpinternal.cxname.com."
    description = "Private zone for agentgw.dev.gcpinternal.cxname.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project     = "cx-pr-agentgw-dev-01"
    record_sets = {}
  },
  "peering-agentgw-dev-gcpinternal-cxname-com" : {
    dns_name    = "agentgw.dev.gcpinternal.cxname.com."
    description = "DNS Peering zone for agentgw.dev.gcpinternal.cxname.com."
    visibility  = "private"
    networks    = ["vpc-g-ssvcs-transit"]
    project     = "cx-pr-ssvcs-transit-nw-01"
    peering_config = {
      target_network = "https://www.googleapis.com/compute/v1/projects/cx-pr-infra-nw-dev-01/global/networks/vpc-name"
    }
  },
}
```

## Deployment Notes

- **Private Zone tfvars**: Place these entries in the appropriate `<sdlc>.tfvars` file (e.g., `dev.tfvars`, `prd.tfvars`) inside the **`cx-gcp-prod-network-iac`** repository.
- **Peering Zone tfvars**: Place these entries in the appropriate `<sdlc>.tfvars` file inside the **`cx-gcp-transit-network-iac`** repository.

