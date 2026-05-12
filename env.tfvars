env_project_id = "infra-proj-id"

vpcs = {
  # "tf-vpc-01" : {
  #   network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  # },
  # "tf-vpc-02" : {
  # },
}

subnetworks = {
  # "tf-vpc-01-sn01-use4" : {
  #   network_name             = "tf-vpc-01"
  #   region                   = "us-east4"
  #   ip_cidr_range            = "192.168.100.0/24"
  #   purpose                  = "PRIVATE"
  #   private_ip_google_access = true
  #   log_config               = {}
  #   secondary_ip_range = {
  #     "pods" : {
  #       range_name    = "pods"
  #       ip_cidr_range = "100.100.0.0/23"
  #     },
  #     "services" : {
  #       range_name    = "services"
  #       ip_cidr_range = "100.100.2.0/23"
  #     },
  #   }
  # }
}

cloud_routers = {
  # "cr-tf-vpc-01-use4" : {
  #   name           = "cr-tf-vpc-01-use4"
  #   network_name   = "tf-vpc-01"
  #   region         = "us-east4"
  #   asn            = 64521
  #   advertise_mode = "CUSTOM"
  #   advertised_ip_ranges = {
  #     "rfc1918-class-a" : {
  #       range       = "10.0.0.0/8"
  #       description = "RFC 1918 Class A"
  #     },
  #     "rfc1918-class-b" : {
  #       range       = "172.16.0.0/12"
  #       description = "RFC 1918 Class B"
  #     },
  #     "rfc1918-class-c" : {
  #       range       = "192.168.0.0/16"
  #       description = "RFC 1918 Class C"
  #     },
  #   }
  #   router_interfaces = {}
  #   router_peers      = {}
  # },
  # "cr-tf-vpc-01-use4-ic" : {
  #   name              = "cr-tf-vpc-01-use4-ic"
  #   network_name      = "tf-vpc-01"
  #   region            = "us-east4"
  #   asn               = 16550
  #   advertise_mode    = "DEFAULT"
  #   router_interfaces = {}
  #   router_peers      = {}
  # },
}

cloud_nats = {
  # "nat-cr-tf-vpc-01-use4" : {
  #   name        = "nat-cr-tf-vpc-01-use4"
  #   region      = "us-east4"
  #   router_name = "cr-tf-vpc-01-use4"
  #   enable      = true
  #   filter      = "TRANSLATIONS_ONLY"
  # }
}

static_routes = {
  # "testroute" : {
  #   dest_range   = "100.65.1.1/32"
  #   network_name = "tf-vpc-01"
  #   priority     = 1000
  #   next_hop_ip  = "192.168.100.100"
  # }
}

policy_based_routes = {
  # "tf-pbr-01" : {
  #   network_name    = "tf-vpc-01"
  #   next_hop_ilb_ip = "10.0.0.10"
  #   priority        = 1000
  #   src_range       = "1.1.1.1/32"
  #   dest_range      = "2.2.2.2/32"
  # }
}


vlan_attachments = {
  # "vlan-att-a" = {
  #   router_name              = "cr-tf-vpc-01-use4-ic"
  #   admin_enabled            = true
  #   edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  # },
  # "vlan-att-b" = {
  #   router_name              = "cr-tf-vpc-01-use4-ic"
  #   admin_enabled            = true
  #   edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  # }
}

subnet_iam_bindings = {
  # "tf-vpc-01-sn01-use4-user" : {
  #   subnetwork_name = "tf-vpc-01-sn01-use4"
  #   role            = "roles/compute.networkUser"
  #   members = [
  #     "user:example@example.com",
  #     "serviceAccount:svc-terraform@<proj-id>.iam.gserviceaccount.com"
  #   ]
  # },
  # "tf-vpc-01-sn01-use4-viewer" : {
  #   subnetwork_name = "tf-vpc-01-sn01-use4"
  #   role            = "roles/compute.networkViewer"
  #   members = [
  #     "serviceAccount:terraform-svc-account@<proj-id>.iam.gserviceaccount.com"
  #   ]
  # }
}

shared_vpcs = {
  # "<svc-proj-01>" : {},
  # "<svc-proj-02>" : {},
  # "<svc-proj-03>" : {}
}

ncc_hubs = {
  # "tf-hub-01" : {
  #   ncc_groups = {
  #     "center" : {
  #       description          = "Central group for core services"
  #       auto_accept_projects = []
  #     },
  #     "edge" : {
  #       description          = "Edge group for workload VPCs"
  #       auto_accept_projects = []
  #     }
  #   }
  # },
  # "tf-hub-02" : {
  # }
}

ncc_spokes = {
  # "spk-tf-vpc-01" : {
  #   name     = "spk-tf-vpc-01"
  #   hub_name = "tf-hub-01"
  #   project  = "<proj-id>"
  #   group    = "center"
  #   linked_vpc_network = {
  #     "tf-vpc-01" : {
  #       uri = "https://www.googleapis.com/compute/v1/projects/<proj-id>/global/networks/tf-vpc-01"
  #     }
  #   }
  # },
  # "spk-tf-vpc-02" : {
  #   name     = "spk-tf-vpc-02"
  #   hub_name = "tf-hub-01"
  #   project  = "<proj-id>"
  #   group    = "edge"
  #   linked_vpc_network = {
  #     "tf-vpc-01" : {
  #       uri = "https://www.googleapis.com/compute/v1/projects/<proj-id>/global/networks/tf-vpc-02"
  #     }
  #   }
  # },
  # "spk-tunnel-vpc01proj01-vpc01proj02" : {
  #   name     = "spk-tunnel-vpc01proj01-vpc01proj02"
  #   hub_name = "tf-hub-01"
  #   location = "us-central1"
  #   linked_vpn_tunnels = {
  #     "tunnel-vpc01proj01-vpc01proj02" : {
  #       uris = [
  #         "https://www.googleapis.com/compute/v1/projects/<proj-id>/regions/us-central1/vpnTunnels/tunnel-01-vpc01proj01-vpc01proj02",
  #         "https://www.googleapis.com/compute/v1/projects/<proj-id>/regions/us-central1/vpnTunnels/tunnel-02-vpc01proj01-vpc01proj02"
  #       ]
  #     }
  #   }
  # }
  # "spk-workload1-psa-db" : {
  #   name     = "spk-workload1-psa-db"
  #   hub_name = "lab-ncc-hub"
  #   # group    = "projects/<proj-id>/locations/global/hubs/lab-ncc-hub/groups/edge"
  #   labels = {}
  #   linked_producer_vpc_network = {
  #     "workload1" : {
  #       network = "https://www.googleapis.com/compute/beta/projects/<proj-id>/global/networks/workload1"
  #       peering = "servicenetworking-googleapis-com"
  #     }
  #   }
  # },
  # "spk-vlan-att" : {
  #   name     = "spk-vlan-att"
  #   hub_name = "tf-hub-01"
  #   project  = "<proj-id>"
  #   group    = "center"
  #   location = "us-central1"
  #   linked_interconnect_attachments = {
  #     "vlan-att-tf-vpc-01" : {
  #       uris = [
  #         "https://www.googleapis.com/compute/v1/projects/<proj-id>/regions/us-central1/interconnectAttachments/vlan-att-a",
  #         "https://www.googleapis.com/compute/v1/projects/<proj-id>/regions/us-central1/interconnectAttachments/vlan-att-b"
  #       ]
  #     }
  #   }
  # },
}

dns_zones = {
  # "gcp-example-com" : {
  #   dns_name    = "gcp.example.com."
  #   description = "Private zone for GCP"
  #   visibility  = "private"
  #   networks    = ["tf-vpc-01"]
  #   record_sets = {
  #     "test-a" : {
  #       name    = "test.gcp.example.com."
  #       type    = "A"
  #       ttl     = 300
  #       rrdatas = ["10.100.1.10"]
  #     }
  #   }
  # },

  # "example-com-forwarding" : {
  #   dns_name    = "example.com."
  #   description = "Forwarding zone to on-prem"
  #   visibility  = "private"
  #   networks    = ["tf-vpc-01"]
  #   forwarding_config = {
  #     target_name_servers = [
  #       {
  #         ipv4_address    = "10.20.30.1"
  #         forwarding_path = "default"
  #       },
  #       {
  #         ipv4_address    = "10.20.30.2"
  #         forwarding_path = "default"
  #       }
  #     ]
  #   }
  # },

  # "peering-zone-example" : {
  #   dns_name    = "peering.example.com."
  #   description = "DNS Peering zone"
  #   visibility  = "private"
  #   networks    = ["tf-vpc-02"]
  #   peering_config = {
  #     target_network = "https://www.googleapis.com/compute/v1/projects/infra-proj-id/global/networks/tf-vpc-01"
  #   }
  # }
}


dns_policies = {
  # "inbound-policy-tf-vpc-01" : {
  #   enable_inbound_forwarding = true
  #   enable_logging            = true
  #   networks                  = ["tf-vpc-01"]
  # }
}

addresses = {
  # "ext-ip-01" : {
  #   address_type = "EXTERNAL"
  #   region       = "us-east4"
  # },
  # "int-ip-01" : {
  #   address_type    = "INTERNAL"
  #   network_name    = "tf-vpc-01"
  #   subnetwork_name = "tf-vpc-01-sn01-use4"
  #   region          = "us-east4"
  # }
}

global_addresses = {
  # "tf-vpc-01-psa-01" : {
  #   address       = "192.168.21.0"
  #   prefix_length = 24
  #   address_type  = "INTERNAL"
  #   purpose       = "VPC_PEERING"
  #   network_name  = "tf-vpc-01"
  # },
  # "tf-vpc-01-psa-02" : {
  #   address       = "192.168.22.0"
  #   prefix_length = 24
  #   address_type  = "INTERNAL"
  #   purpose       = "VPC_PEERING"
  #   network_name  = "tf-vpc-01"
  # },
}

psa = {
  # "tf-vpc-01-psa" : {
  #   network_name                 = "tf-vpc-01"
  #   reserved_peering_ranges_name = ["tf-vpc-01-psa-01", "tf-vpc-01-psa-02"]
  # },
}

firewall_endpoints = {
  # "fwed-usea4a-01" = {
  #   name               = "fwed-usea4a-01"
  #   parent             = "organizations/1234567890"
  #   location           = "us-east4-a"
  #   billing_project_id = "project-abcd"
  #   labels             = {}
  #   fw_ep_associations = {
  #     "network-shared-vpc" : {
  #       fw_ip_association_parent   = "projects/project-abcd"
  #       network                    = "projects/project-abcd/global/networks/network-shared-vpc"
  #       fw_ip_association_location = "us-east4-a"
  #       fw_ep_association_labels   = {}
  #       tls_inspection_policy      = null
  #       disabled                   = false
  #     },
  #   },
  # },
}

hierarchical_fw_policies = {
  # "tf-hfw-pol-001" = {
  #   short_name  = "tf-hfw-pol-001"
  #   description = "Hierarchical Firewall Policy 001"
  #   parent      = "organizations/<org-number>"
  #   fw_policy_associations = {
  #     "tf-hfw-pol-001-assoc-cxdemo-02" = {
  #       association_name  = "tf-hfw-pol-001-assoc-cxdemo-02"
  #       attachment_target = "folders/597023195559"
  #     },
  #   }
  #   fw_policy_rules = {
  #     "1011" = { # Allow IAP Traffic to OST: iap-ssh, iap-rdp
  #       priority                = 1011
  #       direction               = "INGRESS"
  #       action                  = "allow"
  #       rule_name               = "1011"
  #       disabled                = false
  #       description             = "Allow IAP Traffic to OST iap-ssh, iap-rdp"
  #       enable_logging          = true
  #       target_service_accounts = []
  #       target_resources        = []
  #       tls_inspect             = false
  #       target_secure_tags = [
  #         "tagValues/281475312690663",
  #       ]
  #       match = {
  #         src_ip_ranges = ["35.235.240.0/20"]
  #         layer4_configs = [
  #           {
  #             ip_protocol = "tcp"
  #             ports       = ["3389", "22"]
  #           },
  #         ]
  #       }
  #     },
  #   }
  # }
}

global_nw_fw_policies = {
  # "tf-nwfw-pol-001" : {
  #   nw_fw_policy_name        = "tf-nwfw-pol-001"
  #   nw_fw_policy_description = "terraform test of tf-nwfw-pol-001"
  #   nw_fw_policy_project     = "<proj-id>"
  #   association_targets = {
  #     "network-1" = "projects/<proj-id>/global/networks/tf-vpc-01"
  #     "network-2" = "projects/<proj-id>/global/networks/tf-vpc-02"
  #   }
  #   nw_fw_policy_rules = {
  #     "1001" = {
  #       action                  = "deny"
  #       direction               = "INGRESS"
  #       description             = "test rule 1001"
  #       disabled                = false
  #       enable_logging          = true
  #       security_profile_group  = null
  #       target_service_accounts = null
  #       tls_inspect             = false
  #       target_secure_tags = [
  #         "tagValues/281481163640514",
  #       ]
  #       match = {
  #         src_ip_ranges = ["1.1.1.1/32"]
  #         layer4_configs = {
  #           "tcp" = {
  #             ip_protocol = "tcp"
  #             ports       = ["25"]
  #           },
  #           "udp" = {
  #             ip_protocol = "udp"
  #             ports       = ["53"]
  #           },
  #           "icmp" = {
  #             ip_protocol = "icmp"
  #             ports       = []
  #           }
  #         }
  #       }
  #     },
  #   }
  # }
}

secure_tags = {
  # "tag-fw-org-global" : { // example of org-level tag for ngfw firewall policies
  #   parent      = "organizations/<org-number>"
  #   short_name  = "tag-fw-org-global"
  #   description = "test org tag"
  #   purpose_data = {
  #     "organization" = "<org-number>"
  #   }
  #   tag_values = {
  #     "value01" : {
  #       tagvalue_short_name  = "value01"
  #       tagvalue_description = "value01"
  #     },
  #   }
  #   iam_viewer_members = []
  #   iam_user_members   = ["serviceAccount:iac-deployer@<proj-id>.iam.gserviceaccount.com"]
  # },
  # "tag-fw-nw-vpc" : { // example of nw-level tag for ngfw firewall policies
  #   parent      = "projects/506688492995"
  #   short_name  = "tag-fw-nw-vpc"
  #   description = "test nw tag"
  #   purpose_data = {
  #     network = "<proj-id>/tf-vpc-01"
  #   }
  #   tag_values = {
  #     "value01" : {
  #       tagvalue_short_name  = "value01"
  #       tagvalue_description = "value01"
  #     },
  #   }
  #   iam_viewer_members = []
  #   iam_user_members   = ["serviceAccount:iac-deployer@<proj-id>.iam.gserviceaccount.com"]
  # },
}

vpc_peerings = {
  # "tf-vpc-01-to-tf-vpc-02" : {
  #   local_network_peering_name = "tf-vpc-01-to-tf-vpc-02"
  #   peer_network_peering_name  = "tf-vpc-02-to-tf-vpc-01"
  #   local_network_name         = "tf-vpc-01"
  #   peer_network_name          = "tf-vpc-02"
  #   export_local_custom_routes = true
  #   export_peer_custom_routes  = true
  # }
}

network_attachments = {
  # "nw-att-1" : {
  #   subnetwork_name = ["tf-vpc-01-sn01-usc1"]
  #   connection_preference = "ACCEPT_MANUAL"
  #   producer_accept_lists = ["<svc-proj-01>", "<svc-proj-02>"]
  # }
}

vpc_firewall_rules = {
  # "1000" : {
  #   name        = "allow-ssh-from-10-0-0-1-32"
  #   network     = "tf-vpc-01"
  #   project     = "<proj-id>"
  #   description = "Allow SSH from on-prem"
  #   direction   = "INGRESS"
  #   disabled    = false
  #   priority    = 1000
  #   ranges      = ["10.0.0.1/32"]
  #   target_tags = ["allow-ssh"]
  #   log_config = {
  #     metadata = "INCLUDE_ALL_METADATA"
  #   }
  #   allow = [
  #     {
  #       protocol = "tcp"
  #       ports    = ["22"]
  #     }
  #   ]
  # },
  # "1001" : {
  #   name        = "allow-egress-to-8-8-8-8"
  #   network     = "tf-vpc-01"
  #   project     = "<proj-id>"
  #   description = "Allow egress to 8.8.8.8"
  #   direction   = "EGRESS"
  #   disabled    = false
  #   priority    = 1001
  #   ranges      = ["8.8.8.8/32"]
  #   target_tags = ["allow-http"]
  #   log_config = {
  #     metadata = "INCLUDE_ALL_METADATA"
  #   }
  #   allow = [
  #     {
  #       protocol = "tcp"
  #       ports    = ["80"]
  #     }
  #   ]
  # },
}

pscendpoints = {
  "psc-endpoint-01" : { // PSC for regional google apis example
    network_name                 = "tf-vpc-01"
    subnetwork_name              = "tf-vpc-01-sn01-usc1"
    project                      = "<proj-id>"
    region                       = "us-central1"
    address                      = "192.168.100.16"
    create_regional_address      = false
    regional_endpoint_subnetwork = true
    target_google_api            = "storage.us-central1.rep.googleapis.com"
    access_type                  = "REGIONAL"
  },

  "psc-endpoint-01-global" : { // PSC for regional google apis example but with global access enabled
    network_name                 = "tf-vpc-01"
    subnetwork_name              = "tf-vpc-01-sn01-usc1"
    project                      = "<proj-id>"
    region                       = "us-central1"
    address                      = "192.168.100.17"
    create_regional_address      = false
    regional_endpoint_subnetwork = true
    target_google_api            = "storage.us-central1.rep.googleapis.com"
    access_type                  = "GLOBAL"
  },

  "psc-all-apis-global" : { // PSC for all google apis with global address
    network_name            = "tf-vpc-01"
    project                 = "<proj-id>"
    region                  = "us-central1"
    address                 = "192.168.200.10" // has to be part of IP space used in VPC but not belong to an existing subnet
    create_global_address   = true
    target_google_api       = "all-apis"       // change to vpc-sc if using restricted.googleapis.com
    access_type             = "GLOBAL"
    forwarding_rule_name    = "pscallapis"
  },

  # Example for consumer forwarding rule:
  # "psc-consumer-forwarding-rule-01" : {
  #   network_name              = "tf-vpc-01"
  #   subnetwork_name           = "tf-vpc-01-sn01-usc1"
  #   region                    = "us-central1"
  #   address                   = "192.168.100.12"
  #   forwarding_rule_name      = "psc-fr-consumer-01"
  #   target_service_attachment = "projects/producer-project-id/regions/us-central1/serviceAttachments/sa-producer-01"
  #   allow_psc_global_access   = false
  #   no_automate_dns_zone      = true
  # }

  # Example producer service attachment:
  # "psc-service-attachment-01" : {
  #   network_name    = "vpc-security"
  #   subnetwork_name = "vpc-security-sn-usc1"
  #   region          = "us-central1"
  #   address         = "172.16.1.30"
  #
  #   service_attachment = {
  #     name                  = "sa-producer-01"
  #     description           = "Example PSC producer service attachment"
  #     target_service        = "projects/infra-proj-id/regions/us-central1/forwardingRules/producer-ilb"
  #     nat_subnets           = ["projects/infra-proj-id/regions/us-central1/subnetworks/psc-nat-sn-usc1"]
  #     connection_preference = "ACCEPT_AUTOMATIC"
  #     enable_proxy_protocol = false
  #   }
  # }
}