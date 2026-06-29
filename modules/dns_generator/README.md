# DNS Zone tfvars Generator

This helper script automates creating a Terraform `.tfvars` DNS zone entry from a standard GCP project name matching the naming convention:
`nyl-<env>-<function>-<sdlc>-<suffix>`

## Usage

Run the script by passing one or more GCP project names as command-line arguments:

```bash
python3 modules/dns_generator/generate.py <gcp-project-name-1> [gcp-project-name-2] ...
```

### Example

```bash
python3 modules/dns_generator/generate.py nyl-pr-abcd-dev-01 nyl-pr-agentgw-dev-01
```

**Output:**
```hcl
dns_zones = {
  "abcd" : {
    dns_name    = "abcd.dev.gcpinternal.newyorklife.com."
    description = "Private zone for abcd.dev.gcpinternal.newyorklife.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project     = "nyl-pr-abcd-dev-01"
    record_sets = {}
  },
  "agentgw" : {
    dns_name    = "agentgw.dev.gcpinternal.newyorklife.com."
    description = "Private zone for agentgw.dev.gcpinternal.newyorklife.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project     = "nyl-pr-agentgw-dev-01"
    record_sets = {}
  },
}
```
