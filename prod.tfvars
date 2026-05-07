env_project_id = "infra-proj-id"

vpcs = {
  "tf-vpc-01" : {
    network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  },
  "tf-vpc-02" : {
  },
}

subnetworks = {
  "tf-vpc-01-sn01-usc1" : {
    network_name             = "tf-vpc-01"
    region                   = "us-central1"
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
  "cr-tf-vpc-01-usc1" : {
    name           = "cr-tf-vpc-01-usc1"
    network_name   = "tf-vpc-01"
    region         = "us-central1"
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
  "cr-tf-vpc-01-usc1-ic" : {
    name              = "cr-tf-vpc-01-usc1-ic"
    network_name      = "tf-vpc-01"
    region            = "us-central1"
    asn               = 16550
    advertise_mode    = "DEFAULT"
    router_interfaces = {}
    router_peers      = {}
  },
}

cloud_nats = {
  "nat-cr-tf-vpc-01-usc1" : {
    name        = "nat-cr-tf-vpc-01-usc1"
    region      = "us-central1"
    router_name = "cr-tf-vpc-01-usc1"
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

vlan_attachments = {
  # "vlan-att-a" = {
  #   router_name              = "cr-tf-vpc-01-usc1-ic"
  #   admin_enabled            = true
  #   edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  # },
  # "vlan-att-b" = {
  #   router_name              = "cr-tf-vpc-01-usc1-ic"
  #   admin_enabled            = true
  #   edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  # }
}

subnet_iam_bindings = {
  "tf-vpc-01-sn01-usc1-user" : {
    subnetwork_name = "tf-vpc-01-sn01-usc1"
    role            = "roles/compute.networkUser"
    members = [
      "user:example@example.com",
      "serviceAccount:svc-terraform@<proj-id>.iam.gserviceaccount.com"
    ]
  },
  "tf-vpc-01-sn01-usc1-viewer" : {
    subnetwork_name = "tf-vpc-01-sn01-usc1"
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