#env_project_id = "infra-proj-id"

env_project_id = "infra-proj-id"

vpcs = {
  "tf-vpc-01" : {
    network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  },
  "tf-vpc-02" : {
  },
}

subnetworks = {
  "tf-vpc-01-sn01-use4" : {
    network_name             = "tf-vpc-01"
    region                   = "us-east4"
    ip_cidr_range            = "192.168.100.0/24"
    purpose                  = "PRIVATE"
    private_ip_google_access = true
    log_config               = {}
    secondary_ip_range = {
      "pods" : {
        range_name    = "pods"
        ip_cidr_range = "100.100.0.0/23"
      },
      "services" : {
        range_name    = "services"
        ip_cidr_range = "100.100.2.0/23"
      },
    }
  }
}

cloud_routers = {
  "cr-tf-vpc-01-use4" : {
    name           = "cr-tf-vpc-01-use4"
    network_name   = "tf-vpc-01"
    region         = "us-east4"
    asn            = 64521
    advertise_mode = "CUSTOM"
    advertised_ip_ranges = {
      "rfc1918-class-a" : {
        range       = "10.0.0.0/8"
        description = "RFC 1918 Class A"
      },
      "rfc1918-class-b" : {
        range       = "172.16.0.0/12"
        description = "RFC 1918 Class B"
      },
      "rfc1918-class-c" : {
        range       = "192.168.0.0/16"
        description = "RFC 1918 Class C"
      },
    }
    router_interfaces = {}
    router_peers      = {}
  },
  "cr-tf-vpc-01-use4-ic" : {
    name              = "cr-tf-vpc-01-use4-ic"
    network_name      = "tf-vpc-01"
    region            = "us-east4"
    asn               = 16550
    advertise_mode    = "DEFAULT"
    router_interfaces = {}
    router_peers      = {}
  },
}

cloud_nats = {
  "nat-cr-tf-vpc-01-use4" : {
    name        = "nat-cr-tf-vpc-01-use4"
    region      = "us-east4"
    router_name = "cr-tf-vpc-01-use4"
    enable      = true
    filter      = "TRANSLATIONS_ONLY"
  }
}

static_routes = {
  "testroute" : {
    dest_range   = "100.65.1.1/32"
    network_name = "tf-vpc-01"
    priority     = 1000
    next_hop_ip  = "192.168.100.100"
  }
}

policy_based_routes = {
  "tf-pbr-01" : {
    network_name    = "tf-vpc-01"
    next_hop_ilb_ip = "10.0.0.10"
    priority        = 1000
    src_range       = "1.1.1.1/32"
    dest_range      = "2.2.2.2/32"
  }
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
  "tf-vpc-01-sn01-use4-user" : {
    subnetwork_name = "tf-vpc-01-sn01-use4"
    role            = "roles/compute.networkUser"
    members = [
      "user:example@example.com",
      "serviceAccount:svc-terraform@<proj-id>.iam.gserviceaccount.com"
    ]
  },
  "tf-vpc-01-sn01-use4-viewer" : {
    subnetwork_name = "tf-vpc-01-sn01-use4"
    role            = "roles/compute.networkViewer"
    members = [
      "serviceAccount:terraform-svc-account@<proj-id>.iam.gserviceaccount.com"
    ]
  }
}

shared_vpcs = {
  "<svc-proj-01>" : {},
  "<svc-proj-02>" : {},
  "<svc-proj-03>" : {}
}

ncc_hubs = {
  "tf-hub-01" : {
    ncc_groups = {
      "center" : {
        description          = "Central group for core services"
        auto_accept_projects = []
      },
      "edge" : {
        description          = "Edge group for workload VPCs"
        auto_accept_projects = []
      }
    }
  },
  "tf-hub-02" : {
  }
}

dns_zones = {
  "gcp-example-com" : {
    dns_name    = "gcp.example.com."
    description = "Private zone for GCP"
    visibility  = "private"
    networks    = ["tf-vpc-01"]
    record_sets = {
      "test-a" : {
        name    = "test.gcp.example.com."
        type    = "A"
        ttl     = 300
        rrdatas = ["10.100.1.10"]
      }
    }
  },

  "example-com-forwarding" : {
    dns_name    = "example.com."
    description = "Forwarding zone to on-prem"
    visibility  = "private"
    networks    = ["tf-vpc-01"]
    forwarding_config = {
      target_name_servers = [
        {
          ipv4_address    = "10.20.30.1"
          forwarding_path = "default"
        },
        {
          ipv4_address    = "10.20.30.2"
          forwarding_path = "default"
        }
      ]
    }
  },

  "peering-zone-example" : {
    dns_name    = "peering.example.com."
    description = "DNS Peering zone"
    visibility  = "private"
    networks    = ["tf-vpc-02"]
    peering_config = {
      target_network = "https://www.googleapis.com/compute/v1/projects/infra-proj-id/global/networks/tf-vpc-01"
    }
  }
}


dns_policies = {
  "inbound-policy-tf-vpc-01" : {
    enable_inbound_forwarding = true
    enable_logging            = true
    networks                  = ["tf-vpc-01"]
  }
}

addresses = {
  "ext-ip-01" : {
    address_type = "EXTERNAL"
    region       = "us-east4"
  },
  "int-ip-01" : {
    address_type    = "INTERNAL"
    network_name    = "tf-vpc-01"
    subnetwork_name = "tf-vpc-01-sn01-use4"
    region          = "us-east4"
  }
}

hierarchical_fw_policies = {
  # "tf-hfw-pol-001" = {
  #   short_name  = "tf-hfw-pol-001"
  #   description = "Hierarchical Firewall Policy 001"
  #   parent      = "organizations/340934488751"
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

secure_tags = {
  # "tag-fw-org-global" : {   // example of org-level tag for ngfw firewall policies
  #   parent      = "organizations/340934488751"
  #   short_name  = "tag-fw-org-global"
  #   description = "test org tag"
  #   purpose_data = {
  #     "organization" = "340934488751"
  #   }
  #   tag_values = {
  #     "value01" : {
  #       tagvalue_short_name  = "value01"
  #       tagvalue_description = "value01"
  #     },
  #   }
  #   iam_viewer_members = []
  #   iam_user_members   = ["serviceAccount:iac-deployer@infra-proj-id.iam.gserviceaccount.com"]
  # },
  # "tag-fw-nw-vpc" : {   // example of nw-level tag for ngfw firewall policies
  #   parent      = "projects/506688492995"
  #   short_name  = "tag-fw-nw-vpc"
  #   description = "test nw tag"
  #   purpose_data = {
  #     network = "infra-proj-id/tf-vpc-01"
  #   }
  #   tag_values = {
  #     "value01" : {
  #       tagvalue_short_name  = "value01"
  #       tagvalue_description = "value01"
  #     },
  #   }
  #   iam_viewer_members = []
  #   iam_user_members   = ["serviceAccount:iac-deployer@infra-proj-id.iam.gserviceaccount.com"]
  # },
}

pscendpoints = {
  "psc-endpoint-01" : {
    network_name      = "tf-vpc-01"
    subnetwork_name   = "tf-vpc-01-sn01-usc1"
    region            = "us-central1"
    address           = "192.168.100.10"
    target_google_api = "storage.us-central1.rep.googleapis.com"
    access_type       = "REGIONAL"
  },

  "psc-endpoint-01-global" : {
    network_name                            = "tf-vpc-01"
    subnetwork_name                         = "tf-vpc-01-sn01-usc1"
    region                                  = "us-central1"
    address                                 = "192.168.100.13"
    target_google_api                       = "storage.us-central1.rep.googleapis.com"
    regional_endpoint_subnetwork            = true
    regional_endpoint_address_use_self_link = true
    access_type                             = "GLOBAL"
  }

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