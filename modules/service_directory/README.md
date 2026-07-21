# Service Directory Module

This submodule provisions Google Cloud Service Directory Namespaces, Services, and Endpoints. It is designed to register Internal Load Balancer IPs or custom services under a secure internal registry, which can be queried by BigLake Federated Catalogs or external clients over private interconnects without traversing the public internet.

## Usage

```hcl
module "service_directory" {
  source       = "./modules/service_directory"
  project_id   = "my-project-id"
  location     = "us-east4"
  namespace_id = "nyl-aws-namespace"
  labels = {
    application_id      = "lakehouse-federation-01"
    environment         = "prod"
    business_unit       = "data-engineering"
    data_classification = "confidential"
    owner_team          = "data-platform"
    managed_by          = "terraform"
  }

  services = {
    "nyl-aws-s3-service" = {
      metadata = { catalog_type = "databricks-unity" }
    }
  }

  endpoints = {
    "nyl-s3-private-lb-endpoint" = {
      service_id = "nyl-aws-s3-service"
      address    = "10.100.1.50"
      port       = 443
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the GCP project where resources will be created. | `string` | n/a | yes |
| location | The region or location for the Service Directory namespace. | `string` | n/a | yes |
| namespace_id | The ID of the Service Directory namespace. | `string` | n/a | yes |
| labels | Resource labels to apply to the namespace. | `map(string)` | `{}` | no |
| services | A map of Service Directory services to create inside the namespace. | `map(object)` | `{}` | no |
| endpoints | A map of Service Directory endpoints to create inside the defined services. | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace_id | The fully qualified resource ID of the created namespace. |
| namespace_name | The name of the created namespace. |
| service_ids | A map of created service IDs. |
| endpoint_ids | A map of created endpoint IDs. |
