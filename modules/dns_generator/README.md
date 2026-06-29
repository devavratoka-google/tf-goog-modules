# DNS Zone tfvars Generator

This helper script automates creating a Terraform `.tfvars` DNS zone entry from a standard GCP project name matching the naming convention:
`nyl-<env>-<function>-<sdlc>-<suffix>`

## Usage

Run the script by passing the GCP project name as a command-line argument:

```bash
python3 modules/dns_generator/generate.py <gcp-project-name>
```

### Example

```bash
python3 modules/dns_generator/generate.py nyl-pr-nyl360-data-dev-01
```

**Output:**
```hcl
dns_zones = {
  "nyl360-data" : {
    dns_name    = "nyl360-data.dev.gcpinternal.newyorklife.com."
    description = "Private zone for nyl360-data.dev.gcpinternal.newyorklife.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project     = "nyl-pr-nyl360-data-dev-01"
    record_sets = {}
  },
}
```
