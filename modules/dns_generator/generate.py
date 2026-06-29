#!/usr/bin/env python3
import sys
import re

def parse_project(project_name):
    # Regex pattern to match: nyl-<env>-<function>-<sdlc>-<suffix>
    # <env>: pr or np
    # <sdlc>: test, dev, qa, stg, prd
    # <suffix>: \d{2}
    pattern = r"^nyl-(?:pr|np)-(?P<function>.+)-(?P<sdlc>test|dev|qa|stg|prd)-\d{2}$"
    match = re.match(pattern, project_name)
    if not match:
        raise ValueError(
            f"Project name '{project_name}' does not match the expected format: "
            "nyl-<env>-<function>-<sdlc>-<suffix> (e.g., nyl-pr-nyl360-data-dev-01)"
        )
    return match.group("function"), match.group("sdlc")

def generate_tfvars(project_names):
    zones_content = []
    for project_name in project_names:
        project_name = project_name.strip()
        if not project_name:
            continue
        function_name, sdlc = parse_project(project_name)
        
        # 1. Private DNS managed zone
        private_zone = f'''  "{function_name}" : {{
    dns_name    = "{function_name}.{sdlc}.gcpinternal.newyorklife.com."
    description = "Private zone for {function_name}.{sdlc}.gcpinternal.newyorklife.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project     = "{project_name}"
    record_sets = {{}}
  }},'''
        zones_content.append(private_zone)

        # 2. Peering DNS managed zone in nyl-pr-ssvcs-transit-nw-01
        peering_zone = f'''  "peering-{function_name}.{sdlc}.gcpinternal.newyorklife.com" : {{
    dns_name    = "{function_name}.{sdlc}.gcpinternal.newyorklife.com."
    description = "DNS Peering zone for {function_name}.{sdlc}.gcpinternal.newyorklife.com."
    visibility  = "private"
    networks    = ["vpc-g-ssvcs-transit"]
    project     = "nyl-pr-ssvcs-transit-nw-01"
    peering_config = {{
      target_network = "https://www.googleapis.com/compute/v1/projects/nyl-pr-infra-nw-{sdlc}-01/global/networks/vpc-name"
    }}
  }},'''
        zones_content.append(peering_zone)
        
    inner_content = "\n".join(zones_content)
    tfvars = f'''dns_zones = {{\n{inner_content}\n}}'''
    return tfvars

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 generate.py <gcp-project-name-1> [gcp-project-name-2] ...")
        sys.exit(1)
        
    project_names = sys.argv[1:]
    try:
        result = generate_tfvars(project_names)
        print(result)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
