nva_clusters = {
  # usc1_cluster = {
  #   name          = "vpc-security-usc1"
  #   region        = "us-central1"
  #   zone          = "us-central1-a"
  #   network_id    = "projects/infra-proj-id/global/networks/vpc-security"
  #   subnetwork_id = "projects/infra-proj-id/regions/us-central1/subnetworks/vpc-security-sn-usc1"

  #   resource_manager_tags = {
  #     "tagKeys/281480126525795" = "tagValues/281477869187443"
  #     "tagKeys/281476151645525" = "tagValues/281479489001482"
  #   }

  #   # Keys (vm11, vm12) combine with the `name` to generate the final GCP resource name 
  #   # (e.g. "vpc-security-usc1-vm11")
  #   vms = {
  #     vm11 = { address = "172.16.1.25" }
  #     vm12 = { address = "172.16.1.26" }
  #   }
  # }

  # use4_cluster = {
  #   name          = "vpc-security-use4"
  #   region        = "us-east4"
  #   zone          = "us-east4-a"
  #   network_id    = "projects/infra-proj-id/global/networks/vpc-security"
  #   subnetwork_id = "projects/infra-proj-id/regions/us-east4/subnetworks/vpc-security-sn-use4"

  #   resource_manager_tags = {
  #     "tagKeys/281480126525795" = "tagValues/281477869187443"
  #     "tagKeys/281476151645525" = "tagValues/281479489001482"
  #   }

  #   # Keys (vm13, vm14) combine with the `name` to generate the final GCP resource name 
  #   # (e.g. "vpc-security-use4-vm13")
  #   vms = {
  #     vm13 = { address = "172.16.2.25" }
  #     vm14 = { address = "172.16.2.26" }
  #   }
  # }
}