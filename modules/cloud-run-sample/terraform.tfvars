# The target Google Cloud Project ID.
project_id = "nyl-cloud-run"

# The target Google Cloud region.
region = "asia-south1"

# The name of the Cloud Run service.
service_name = "service-hello-world"

# Containers in name => attributes format.
containers = {
  hello-world = {
    image = "us-docker.pkg.dev/cloudrun/container/hello:latest"
    resources = {
      limits = {
        cpu    = "1"
        memory = "512Mi"
      }
    }
    ports = {
      default = {
        container_port = 8080
      }
    }
  }
}

# The name or self-link of the target VPC network.
vpc_network = "cloud-run-vpc"

# The name or self-link of the target subnetwork.
vpc_subnetwork = "asia-south1"

# Environment variables to inject into the container.
# container_env = {
#   EXAMPLE_VAR_KEY = "example-var-value"
# }

# (Optional) The email address of the service account used by the portal to invoke the Cloud Run service.
# portal_invoker_sa_email = "portal-invoker-sa@your-gcp-project-id.iam.gserviceaccount.com"

# (Optional) The email address of the WIF service account used by CI/CD to invoke the Cloud Run service.
# shared_wif_service_account = "cicd-wif-sa@your-gcp-project-id.iam.gserviceaccount.com"

# (Optional) List of backend service service accounts authorized to invoke the Cloud Run service.
# service_invoker_sa_emails = [
#   "backend-service-1-sa@your-gcp-project-id.iam.gserviceaccount.com",
#   "backend-service-2-sa@your-gcp-project-id.iam.gserviceaccount.com"
# ]
