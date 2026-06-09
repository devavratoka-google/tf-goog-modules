terraform {
  required_version = ">= 1.3"

  provider_meta "google" {
    module_name = "tf-goog-modules/network_attachments/v1.0.0"
  }
}
