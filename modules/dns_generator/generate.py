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

def generate_tfvars(project_name):
    function_name, sdlc = parse_project(project_name)
    
    tfvars = f'''dns_zones = {{
  "{function_name}" : {{
    dns_name    = "{function_name}.{sdlc}.gcpinternal.newyorklife.com."
    description = "Private zone for {function_name}.{sdlc}.gcpinternal.newyorklife.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project     = "{project_name}"
    record_sets = {{}}
  }},
}}'''
    return tfvars

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 generate.py <gcp-project-name>")
        sys.exit(1)
        
    project_name = sys.argv[1].strip()
    try:
        result = generate_tfvars(project_name)
        print(result)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
