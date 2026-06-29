env_project_id = "infra-proj-id"

vpcs = {
  # "tf-vpc-01" : {
  # },
}

subnetworks = {
  # "tf-vpc-01-sn01-usc1" : {
  #   network_name             = "tf-vpc-01"
  #   region                   = "us-central1"
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
  # },
  # "tf-vpc-01-rmproxy" : {
  #   network_name  = "tf-vpc-01"
  #   region        = "us-east4"
  #   ip_cidr_range = "192.168.101.0/24"
  #   purpose       = "REGIONAL_MANAGED_PROXY"
  #   role          = "ACTIVE"
  # }
  # "tf-vpc-01-pscc" : {
  #   network_name  = "tf-vpc-01"
  #   region        = "us-east4"
  #   ip_cidr_range = "192.168.102.0/24"
  #   purpose       = "PRIVATE_SERVICE_CONNECT"
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
  #       auto_accept_projects = ["infra-proj-id"]
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
  "ny1360-data" : {
    dns_name    = "ny1360-data.dev.gcpinternal.newyorklife.com."
    description = "Private zone for ny1360-data.dev.gcpinternal.newyorklife.com"
    visibility  = "private"
    networks    = ["vpc-name"]
    project = "nyl-pr-ny1360-data-dev-01"
    member      = "serviceAccount:my-service-account@my-project.iam.gserviceaccount.com"
    record_sets = {}
  },

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

dns_record_sets = {
  # "test-record" = {
  #   managed_zone = "gcp-example-com"
  #   name         = "test.gcp.example.com."
  #   type         = "A"
  #   ttl          = 300
  #   rrdatas      = ["10.100.1.10"]
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
  #   connection_preference = "ACCEPT_AUTOMATIC"
  #  # producer_accept_lists = ["<svc-proj-01>", "<svc-proj-02>"] // not needed for ACCEPT_AUTOMATIC
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

  "psc-all-apis-global" : { // PSC for all google apis with global address
    network_name          = "tf-vpc-01"
    project               = "proj-oka-int-demo"
    address               = "192.168.104.10" // has to be part of IP space used in VPC but not belong to an existing subnet
    create_global_address = true
    target_google_api     = "all-apis" // change to vpc-sc if using restricted.googleapis.com
    access_type           = "GLOBAL"
    forwarding_rule_name  = "pscallapis"
    service_directory_registrations = {
      namespace                = "my-namespace"
      service_directory_region = "us-central1"
    }
  },

  "psc-endpoint-01" : { // PSC for regional google apis example
    network_name                 = "tf-vpc-01"
    subnetwork_name              = "tf-vpc-01-sn-psc-outbound"
    project                      = "proj-oka-int-demo"
    region                       = "us-central1"
    address                      = "192.168.103.20"
    create_regional_address      = false
    regional_endpoint_subnetwork = true
    target_google_api            = "storage.us-central1.rep.googleapis.com"
    access_type                  = "REGIONAL"
  },

  "psc-endpoint-01-global" : { // PSC for regional google apis example but with global access enabled
    network_name                 = "tf-vpc-01"
    subnetwork_name              = "tf-vpc-01-sn-psc-outbound"
    project                      = "proj-oka-int-demo"
    region                       = "us-central1"
    address                      = "192.168.103.21"
    create_regional_address      = false
    regional_endpoint_subnetwork = true
    target_google_api            = "bigquery.us-central1.rep.googleapis.com"
    access_type                  = "GLOBAL"
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

cloud_run_v2 = {
  #   "service-hello-world" : {
  #     region              = "us-central1"
  #     deletion_protection = "false"

  #     service_config = {
  #       ingress = "INGRESS_TRAFFIC_ALL"
  #       # Max request duration. SSE connections to GKE pods can be long-lived.
  #       # When this timeout fires, the browser's EventSource auto-reconnects.
  #       # See docs/robin-migration/07-understanding-sse.md for the full lifecycle.
  #       timeout = "3600s"

  #       scaling = {
  #         # Keep one control-plane instance warm because it runs background workspace
  #         # lifecycle loops; this is cheaper than letting session pods linger.
  #         min_instance_count = 1
  #         max_instance_count = 10
  #       }
  #     }

  #     revision = {
  #       # Direct VPC egress for Cloud Run -> GKE communication
  #       vpc_access = {
  #         network = "tf-vpc-01"
  #         subnet  = "tf-vpc-01-sn01-usc1"
  #         egress  = "ALL_TRAFFIC"
  #       }
  #     }

  #     service_account_config = {
  #       create = false
  #       email  = "<project-number>-compute@developer.gserviceaccount.com" # maps to google_service_account.runtime.email
  #     }

  #     containers = {
  #       "default" : {
  #         image = "us-central1-docker.pkg.dev/<project-id>/dockerhub-remote-test/nginxdemos/hello:latest"

  #         resources = {
  #           limits = {
  #             cpu    = "1"
  #             memory = "512Mi"
  #           }
  #         }

  #         ports = {
  #           "http" = {
  #             container_port = 80
  #           }
  #         }
  #       }
  #     }

  #     # Cloud Run IAM bindings
  #     iam = {
  #       "roles/run.invoker" = ["allUsers"]
  #     }
  #   }
}

bigquery_datasets = {
  #   "analytics" = {
  #     location            = "us-east4"
  #     deletion_protection = false

  #     tables = [
  #       {
  #         table_id = "events"
  #         schema   = <<-EOT
  #           [
  #             {"name": "event_timestamp", "type": "TIMESTAMP", "mode": "REQUIRED"},
  #             {"name": "user_id",         "type": "STRING",    "mode": "REQUIRED"},
  #             {"name": "event_name",      "type": "STRING",    "mode": "REQUIRED"},
  #             {"name": "properties",      "type": "JSON",      "mode": "NULLABLE"}
  #           ]
  #         EOT
  #         time_partitioning = {
  #           type          = "DAY"
  #           field         = "event_timestamp"
  #           expiration_ms = "7776000000"
  #         }
  #         clustering = ["user_id", "event_name"]
  #         labels     = {}
  #       }
  #     ]
  #   }
}

gcs_buckets = {
  # "my-app-data-bucket" = {
  #   project_id               = "nyl01-iac-deploy"
  #   location                 = "us-east4"
  #   force_destroy            = false
  #   storage_class            = "STANDARD"
  #   bucket_policy_only       = true
  #   versioning               = true
  #   public_access_prevention = "inherited"
  #   
  #   labels = {
  #     application_id      = "app-123"
  #     environment         = "dev"
  #     business_unit       = "nyl"
  #     data_classification = "confidential"
  #     owner_team          = "devops"
  #     managed_by          = "terraform"
  #   }
  # }
}

cloud_sql_mssql = {
  # "app-mssql" = {
  #   region           = "us-east4"
  #   database_version = "SQLSERVER_2019_STANDARD"
  #   tier             = ""
  #   availability_type = "REGIONAL"

  #   db_name              = "appdb"
  #   user_name            = "app"
  #   root_password        = ""
  #   deletion_protection  = true

  #   disk_size       = 20
  #   disk_autoresize = true

  #   backup_configuration = {
  #     enabled                        = true
  #     point_in_time_recovery_enabled = true
  #     start_time                     = "03:00"
  #     retained_backups               = 7
  #     retention_unit                 = "COUNT"
  #     binary_log_enabled             = null
  #     transaction_log_retention_days = "3"
  #     location                       = null
  #   }

  #   ip_configuration = {
  #     ipv4_enabled    = false
  #     private_network = "projects/HOST_PROJ/global/networks/shared-vpc"
  #     ssl_mode        = "ENCRYPTED_ONLY"
  #   }

  #   user_labels = { env = "dev", app = "core" }
  # }
}

cloud_sql_mysql = {
  # "app-mysql" = {
  #   region           = "us-east4"
  #   database_version = "MYSQL_8_0"
  #   tier             = "db-n1-standard-2"
  #   availability_type = "REGIONAL"

  #   db_name              = "appdb"
  #   user_name            = "app"
  #   deletion_protection  = true

  #   disk_size       = 20
  #   disk_autoresize = true

  #   backup_configuration = {
  #     enabled                        = true
  #     binary_log_enabled             = true # necessario para PITR e read replicas
  #     start_time                     = "03:00"
  #     retained_backups               = 7
  #     transaction_log_retention_days = "3"
  #   }

  #   ip_configuration = {
  #     ipv4_enabled    = false
  #     private_network = "projects/HOST_PROJ/global/networks/shared-vpc"
  #     ssl_mode        = "ENCRYPTED_ONLY"
  #   }

  #   database_flags = [
  #     { name = "slow_query_log", value = "on" },
  #     { name = "long_query_time", value = "1" }
  #   ]

  #   user_labels = { env = "dev", app = "core" }
  # }
}

cloud_sql_postgresql = {
  # "pg-instance" = {
  #   project_id          = "<proj-id>"
  #   region              = "us-central1"
  #   database_version    = "POSTGRES_15"
  #   tier                = "db-custom-2-7680"
  #   edition             = "ENTERPRISE"
  #   availability_type   = "ZONAL"
  #   deletion_protection = false

  #   psc_network_link    = "tf-vpc-01"
  #   psc_subnetwork_link = "tf-vpc-01-sn01-usc1"
  #   # network_attachment_link = "nw-att-1"

  #   ip_configuration = {
  #     ipv4_enabled = false
  #     psc_enabled  = true
  #     psc_allowed_consumer_projects = [
  #       "<proj-id>"
  #     ]
  #   }
  # },
  # "pg-instance2" = {
  #   project_id          = "<proj-id>"
  #   region              = "us-central1"
  #   database_version    = "POSTGRES_17"
  #   tier                = "db-f1-micro"
  #   edition             = "ENTERPRISE"
  #   availability_type   = "ZONAL"
  #   deletion_protection = false

  #   psc_network_link        = "tf-vpc-01"
  #   psc_subnetwork_link     = "tf-vpc-01-sn01-usc1"
  #   network_attachment_link = "nw-att-2"

  #   ip_configuration = {
  #     ipv4_enabled = false
  #     psc_enabled  = true
  #     psc_allowed_consumer_projects = [
  #       "<proj-id>"
  #     ]
  #   }
  # },
  # "pg-instance3" = {
  #   project_id          = "<proj-id>"
  #   region              = "us-central1"
  #   database_version    = "POSTGRES_17"
  #   tier                = "db-f1-micro"
  #   edition             = "ENTERPRISE"
  #   availability_type   = "ZONAL"
  #   deletion_protection = false

  #   psc_network_link        = "tf-vpc-01"
  #   psc_subnetwork_link     = "tf-vpc-01-sn01-usc1"
  #   network_attachment_link = "nw-att-2"

  #   ip_configuration = {
  #     ipv4_enabled = false
  #     psc_enabled  = true
  #     psc_allowed_consumer_projects = [
  #       "<proj-id>"
  #     ]
  #   }
  # },
  #   "pg-instance4" = {
  #   project_id          = "<proj-id>"
  #   region              = "us-central1"
  #   database_version    = "POSTGRES_17"
  #   tier                = "db-f1-micro"
  #   edition             = "ENTERPRISE"
  #   availability_type   = "ZONAL"
  #   deletion_protection = false

  #   psc_network_link        = "tf-vpc-01"
  #   psc_subnetwork_link     = "tf-vpc-01-sn01-usc1"
  #   network_attachment_link = "nw-att-2"

  #   ip_configuration = {
  #     ipv4_enabled = false
  #     psc_enabled  = true
  #     psc_allowed_consumer_projects = [
  #       "<proj-id>"
  #     ]
  #   }
  # },
}

# -----------------------------------------------------------------------------
# IAM Custom Roles
# -----------------------------------------------------------------------------
# Local module: ./modules/iam-custom-role
# Each entry creates a custom role (project- or org-scoped). The `name` output
# of each role is auto-injected into iam_service_accounts[*].context.custom_roles
# by the root main.tf, so it can be referenced as "$custom_roles:<key>" from any
# iam_service_accounts binding (iam_project_roles, iam_bindings,
# iam_bigquery_dataset_roles, iam_folder_roles, iam_organization_roles, etc.).
iam_custom_roles = {
  "vmRuntimeReader" = {
    project_id  = "infra-proj-id"
    role_id     = "vmRuntimeReader"
    title       = "VM Runtime Reader (test)"
    description = "Throwaway custom role to validate the local iam-custom-role module."
    permissions = [
      "logging.logEntries.create",
      "monitoring.timeSeries.create",
    ]
  }

  # --- Org-scoped custom role -------------------------------------------------
  # GCP only allows defining custom roles at project or organization scope.
  # Folder is NOT supported by the API. To use the same role across multiple
  # projects/folders, define it at the org and bind it at any level via the
  # iam_service_account module (iam_project_roles, iam_folder_roles, etc.).
  #
  # "orgVmAuditor" = {
  #   org_id      = "1234567890" # Numeric organization ID
  #   role_id     = "orgVmAuditor"
  #   title       = "Org VM Auditor"
  #   description = "Read-only role to audit VMs across any project in the org."
  #   permissions = [
  #     "compute.instances.get",
  #     "compute.instances.list",
  #     "compute.zones.list",
  #     "compute.regions.list",
  #   ]
  # }
}

iam_service_accounts = {
  "tf-iam-sa-test" = {
    name         = "tf-iam-sa-test"
    project_id   = "infra-proj-id"
    display_name = "tf-iam-sa-test"
    description  = "Throwaway SA to validate the local iam-service-account module."

    iam_project_roles = {
      "infra-proj-id" = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
      ]
    }
  }

  "tf-iam-sa-custom-role-test" = {
    name         = "tf-iam-sa-custom-role-test"
    project_id   = "infra-proj-id"
    display_name = "tf-iam-sa-custom-role-test"
    description  = "Throwaway SA to validate iam-custom-role + iam-service-account integration."

    iam_project_roles = {
      "infra-proj-id" = [
        "projects/infra-proj-id/roles/vmRuntimeReader",
      ]
    }
  }


  # ===========================================================================
  # COOKBOOK: commented examples covering every binding scope.
  # Uncomment the block you want to test and adjust IDs/emails for real
  # resources. Each block creates its own throwaway SA unless it explicitly
  # sets service_account_reuse to bind onto an existing service account.
  # ===========================================================================

  # --- 1) Bind on an EXISTING SA (e.g. the SA attached to a GCE VM) ----------
  # "ex-existing-sa" = {
  #   name                  = "vm-runtime@infra-proj-id.iam.gserviceaccount.com"
  #   service_account_reuse = { use_data_source = false }
  #   iam_project_roles = {
  #     "infra-proj-id" = ["roles/storage.objectViewer"]
  #   }
  # }

  # --- 2) Roles on a GCS BUCKET (granular, per bucket) -----------------------
  # iam_storage_roles creates one google_storage_bucket_iam_member per
  # (bucket, role) pair. Accepts multiple buckets and multiple roles per bucket.
  # "ex-gcs" = {
  #   name         = "tf-iam-sa-gcs"
  #   project_id   = "infra-proj-id"
  #   iam_storage_roles = {
  #     "my-data-bucket" = [
  #       "roles/storage.objectViewer",
  #       "roles/storage.legacyBucketReader",
  #     ]
  #     "my-staging-bucket" = [
  #       "roles/storage.objectAdmin",
  #     ]
  #   }
  # }

  # --- 3) Roles on a BigQuery DATASET (local extension) ----------------------
  # iam_bigquery_dataset_roles creates one google_bigquery_dataset_iam_member
  # per (dataset, role) pair. Key format: "project_id/dataset_id" (validated).
  # "ex-bq" = {
  #   name         = "tf-iam-sa-bq"
  #   project_id   = "infra-proj-id"
  #   iam_bigquery_dataset_roles = {
  #     "infra-proj-id/analytics" = [
  #       "roles/bigquery.dataViewer",
  #     ]
  #     "infra-proj-id/staging" = [
  #       "roles/bigquery.dataEditor",
  #     ]
  #   }
  # }

  # --- 4) Roles on a FOLDER --------------------------------------------------
  # iam_folder_roles creates one google_folder_iam_member per (folder, role)
  # pair. Use together with an ORG-scoped custom role (defined in
  # iam_custom_roles above as "orgVmAuditor") or with predefined roles.
  # Reminder: GCP does NOT allow DEFINING a custom role on a folder, but you
  # CAN GRANT any existing role (predefined or org-scoped custom) on a folder.
  # "ex-folder" = {
  #   name         = "tf-iam-sa-folder"
  #   project_id   = "infra-proj-id"
  #   iam_folder_roles = {
  #     "folders/9876543210" = [
  #       "roles/viewer",
  #       "$custom_roles:orgVmAuditor", # requires iam_custom_roles.orgVmAuditor to be uncommented
  #     ]
  #   }
  # }

  # --- 5) Roles on the ORGANIZATION ------------------------------------------
  # iam_organization_roles creates one google_organization_iam_member per
  # (org, role) pair. Be careful: org-level roles inherit down to EVERYTHING.
  # Use sparingly and prefer the most restrictive scope possible.
  # "ex-org" = {
  #   name         = "tf-iam-sa-org"
  #   project_id   = "infra-proj-id"
  #   iam_organization_roles = {
  #     "1234567890" = [
  #       "roles/logging.viewer",
  #     ]
  #   }
  # }

  # --- 6) Impersonation Direction 1: this module manages the TARGET SA -------
  # `iam` = authoritative bindings ON this SA (overwrites any binding for the
  # listed roles made outside Terraform). Use iam_bindings_additive when you
  # need to coexist with legacy IAM that you do not want to overwrite.
  # "ex-sa-target" = {
  #   name         = "tf-iam-sa-target"
  #   project_id   = "infra-proj-id"
  #   iam = {
  #     "roles/iam.serviceAccountUser" = [
  #       "serviceAccount:caller@infra-proj-id.iam.gserviceaccount.com",
  #       "group:platform-eng@example.com",
  #     ]
  #     "roles/iam.serviceAccountTokenCreator" = [
  #       "serviceAccount:caller@infra-proj-id.iam.gserviceaccount.com",
  #     ]
  #   }
  # }
  #
  # Additive variant (does not overwrite existing bindings):
  # "ex-sa-target-additive" = {
  #   name         = "tf-iam-sa-target-additive"
  #   project_id   = "infra-proj-id"
  #   iam_bindings_additive = {
  #     "caller-tokencreator" = {
  #       role   = "roles/iam.serviceAccountTokenCreator"
  #       member = "serviceAccount:caller@infra-proj-id.iam.gserviceaccount.com"
  #     }
  #   }
  # }
  # --- 7) Impersonation Direction 2: this module manages the CALLER SA -------
  # iam_sa_roles grants roles to THIS SA on OTHER service accounts.
  # Format: { "target_sa_email" = [roles] }
  # "ex-sa-caller" = {
  #   name         = "tf-iam-sa-caller"
  #   project_id   = "infra-proj-id"
  #   iam_sa_roles = {
  #     "target1@infra-proj-id.iam.gserviceaccount.com" = [
  #       "roles/iam.serviceAccountTokenCreator",
  #     ]
  #     "target2@other-proj.iam.gserviceaccount.com" = [
  #       "roles/iam.serviceAccountUser",
  #     ]
  #   }
  # }

  # --- 8) Cloud SQL: NO per-database / per-instance IAM in GCP ---------------
  # Per GCP docs (Cloud SQL > IAM > Roles and permissions), Cloud SQL IAM is
  # project-scoped only. There is no google_sql_database_iam_*, no
  # google_sql_instance_iam_*. The closest you can get to "database-level"
  # access control is one of:
  #   a) SQL-native GRANTs (CONNECT, USAGE, SELECT on schema/table) issued
  #      via psql/mysql against the instance after the user is created.
  #      Out of scope for IAM modules.
  #   b) IAM Conditions on the project-level binding to restrict the role to
  #      a specific instance (e.g. resource.name ==
  #      "projects/X/instances/Y"). The fabric iam-service-account v55.1.0
  #      module's iam_project_roles variable is map(list(string)) and does
  #      NOT expose `condition` blocks, so conditional project bindings would
  #      require a separate raw google_project_iam_member resource or a
  #      local module extension. Not implemented here.
  #   c) IAM Group authentication: members of an IAM group are mapped to a
  #      SQL user; SQL-native GRANTs then control per-database access.
  #      Configured via google_sql_user (type = "CLOUD_IAM_GROUP" or
  #      "CLOUD_IAM_SERVICE_ACCOUNT"), not by this module.
  #
  # Recommended pattern for a service account that needs to talk to Cloud SQL:
  #   1) Project-level roles on the SA:
  #        - roles/cloudsql.client       (REQUIRED to connect via Auth Proxy)
  #        - roles/cloudsql.instanceUser (only if using IAM DB authentication)
  #   2) Create the matching SQL user with type = "CLOUD_IAM_SERVICE_ACCOUNT"
  #      via the google_sql_user resource (separate module).
  #   3) Issue SQL-native GRANTs (CONNECT, USAGE, SELECT, ...) directly on the
  #      database/schema/tables for fine-grained access.
  #   4) If the SA needs to import/export to GCS, also grant
  #      roles/storage.objectAdmin on the relevant bucket (see block 2).
  #
  # "ex-cloudsql" = {
  #   name         = "tf-iam-sa-cloudsql"
  #   project_id   = "infra-proj-id"
  #   iam_project_roles = {
  #     "infra-proj-id" = [
  #       "roles/cloudsql.client",       # required to connect via Cloud SQL Auth Proxy
  #       "roles/cloudsql.instanceUser", # only when using IAM DB authentication
  #     ]
  #   }
  #   # If this SA imports/exports from/to GCS:
  #   # iam_storage_roles = {
  #   #   "my-sql-import-bucket" = ["roles/storage.objectAdmin"]
  #   # }
  # }
}

# pubsub_topics = {
#   "agent-events-dev" = {
#     project_id                 = "infra-proj-id"
#     message_retention_duration = "604800s" # 7 days
#     labels                     = { env = "dev", service = "events" }
#
#     topic_iam = {
#       "roles/pubsub.publisher" = [
#         "serviceAccount:publisher-sa@infra-proj-id.iam.gserviceaccount.com"
#       ]
#     }
#
#     subscriptions = {
#       "events-push" = {
#         ack_deadline_seconds = 20
#         push_config = {
#           push_endpoint = "https://orchestrator.run.app/internal/events"
#           oidc_token = {
#             service_account_email = "pubsub-invoker@infra-proj-id.iam.gserviceaccount.com"
#             audience              = "https://orchestrator.run.app"
#           }
#         }
#       }
#       "events-bq-firehose" = {
#         bigquery_config = {
#           table          = "projects/infra-proj-id/datasets/analytics/tables/events"
#           write_metadata = true
#         }
#         iam = {
#           "roles/pubsub.subscriber" = [
#             "serviceAccount:runtime-sa@infra-proj-id.iam.gserviceaccount.com"
#           ]
#         }
#       }
#     }
#   }
# }