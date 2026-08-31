# health_checks = {
#   # Example 1: Basic HTTP health check
#   "web-http-hc" = {
#     description        = "Basic HTTP health check for web tier"
#     region             = "us-central1"
#     check_interval_sec = 10
#     http_health_check = {
#       port         = 80
#       request_path = "/healthz"
#     }
#   }

#   # Example 2: TCP health check with custom thresholds and logging enabled
#   "db-tcp-hc" = {
#     description         = "TCP health check for database tier"
#     region              = "us-central1"
#     healthy_threshold   = 3
#     unhealthy_threshold = 3

#     log_config = {
#       enable = true
#     }

#     tcp_health_check = {
#       port = 5432
#     }
#   }

#   # Example 3: HTTPS health check with a specific host and proxy header
#   "secure-api-https-hc" = {
#     description = "HTTPS check for API gateway"
#     region      = "us-east4"

#     https_health_check = {
#       port         = 443
#       request_path = "/api/v1/status"
#       host         = "api.example.com"
#       proxy_header = "PROXY_V1"
#     }
#   }

#   # Example 4: gRPC health check
#   "internal-grpc-hc" = {
#     description = "gRPC health check for internal microservices"
#     region      = "us-west1"

#     grpc_health_check = {
#       port              = 8080
#       grpc_service_name = "InternalAuthService"
#     }
#   }
# }

# backend_services = {

#   # 1. Unmanaged Instance Group (Requires a balancing mode, usually UTILIZATION or CONNECTION)
#   "mig-backend-srv" = {
#     region                = "us-central1"
#     description           = "Backend service for Unmanaged Instance Group"
#     load_balancing_scheme = "INTERNAL"
#     protocol              = "TCP"
#     # FIXED: Pointed to regional health check and matched the name defined above
#     health_checks = ["projects/<proj-id>/regions/us-central1/healthChecks/db-tcp-hc"]

#     backends = [
#       {
#         # FIXED: Matched the name of the instance group defined below
#         group          = "projects/<proj-id>/zones/us-central1-a/instanceGroups/web-unmanaged-ig"
#         balancing_mode = "CONNECTION"
#       }
#     ]
#   }

#   # 2. Zonal Network Endpoint Group (NEG)
#   "zonal-neg-backend-srv" = {
#     region                = "us-central1"
#     description           = "Backend service for Zonal NEGs"
#     load_balancing_scheme = "INTERNAL_MANAGED"
#     protocol              = "HTTP"
#     # FIXED: Pointed to regional health check and matched the name defined above
#     health_checks = ["projects/<proj-id>/regions/us-central1/healthChecks/web-http-hc"]

#     log_config = {
#       enable      = true
#       sample_rate = 0.5
#     }

#     backends = [
#       {
#         # FIXED: Matched the name of the zonal NEG defined below
#         group                 = "projects/<proj-id>/zones/us-central1-a/networkEndpointGroups/my-populated-zonal-neg"
#         balancing_mode        = "RATE"
#         max_rate_per_endpoint = 50
#         capacity_scaler       = 1.0
#       }
#     ]
#   }

#   # 3. Serverless NEG (Cloud Run / Cloud Functions)
#   "serverless-neg-backend-srv" = {
#     region                = "us-central1"
#     description           = "Backend service for Cloud Run"
#     load_balancing_scheme = "INTERNAL_MANAGED"
#     protocol              = "HTTP"
#     health_checks         = []

#     backends = [
#       {
#         # FIXED: Matched the name of the Serverless NEG defined below
#         group = "projects/<proj-id>/regions/us-central1/networkEndpointGroups/my-cloudrun-neg"
#       }
#     ]
#   }

# }

# instance_groups = {

#   # Example 1: Basic group with instances and a named port (Common for Load Balancing)
#   "web-unmanaged-ig" = {
#     zone        = "us-central1-a"
#     description = "Web servers for the main application"
#     network     = "projects/<proj-id>/global/networks/vpc-p-workload-01"

#     instances = [
#       "projects/<proj-id>/zones/us-central1-a/instances/vpc-p-workload-01-vm01"
#     ]

#     named_ports = [
#       {
#         name = "http"
#         port = 80
#       },
#       {
#         name = "https"
#         port = 443
#       }
#     ]
#   }

#   # Example 2: Empty group (You might attach instances later via scripts or other pipelines)
#   "db-unmanaged-ig" = {
#     zone        = "us-central1-a"
#     description = "Database servers (instances added dynamically)"
#     network     = "projects/<proj-id>/global/networks/vpc-p-workload-01"
#   }

#   # Example 3: Internal backend group with custom port
#   "api-backend-ig" = {
#     zone        = "us-east4-a"
#     description = "Internal API backend group"

#     instances = [
#       "projects/<proj-id>/zones/us-east4-a/instances/vpc-p-workload-01-vm02"
#     ]

#     named_ports = [
#       {
#         name = "grpc"
#         port = 50051
#       }
#     ]
#   }

# }

# negs = {

#   # Zonal NEG with statically attached VM endpoints
#   "my-populated-zonal-neg" = {
#     network_endpoint_type = "GCE_VM_IP_PORT"
#     description           = "Zonal NEG with attached VMs"
#     network               = "projects/<proj-id>/global/networks/vpc-p-workload-01"
#     subnetwork            = "projects/<proj-id>/regions/us-central1/subnetworks/vpc-p-workload-01-sn-usc1"
#     zone                  = "us-central1-a"
#     default_port          = 80

#     endpoints = {
#       "vm-01" = {
#         instance   = "vpc-p-workload-01-vm01"
#         ip_address = "10.1.1.100"
#         port       = 80
#       }
#     }
#   }

#   # Example 2: Serverless NEG pointing to a specific Cloud Run service
#   "my-cloudrun-neg" = {
#     network_endpoint_type = "SERVERLESS"
#     description           = "Serverless NEG for frontend Cloud Run service"
#     region                = "us-central1"

#     cloud_run = {
#       service = "frontend-service-name"
#     }
#   }

#   # Example 3: Serverless NEG using URL masking for multiple Cloud Run services
#   "my-url-masked-cloudrun-neg" = {
#     network_endpoint_type = "SERVERLESS"
#     description           = "Routes to multiple Cloud Run services based on URL"
#     region                = "us-central1"

#     cloud_run = {
#       url_mask = "<service>.example.com"
#     }
#   }

#   # Example 4: Serverless NEG for a Cloud Function
#   "my-cloudfunction-neg" = {
#     network_endpoint_type = "SERVERLESS"
#     region                = "us-central1"

#     cloud_function = {
#       function = "my-data-processing-func"
#     }
#   }

#   # Example 5: Hybrid NEG (Cross-cloud or on-premises target, instance is omitted)
#   "my-hybrid-neg" = {
#     network_endpoint_type = "NON_GCP_PRIVATE_IP_PORT"
#     description           = "Hybrid NEG for remote AWS Databricks endpoint over Interconnect"
#     network               = "projects/<proj-id>/global/networks/vpc-crosscloud-01"
#     zone                  = "us-east4-a"

#     endpoints = {
#       "aws-node-01" = {
#         ip_address = "10.100.1.50" # Remote AWS Private IP
#         port       = 443
#       }
#     }
#   }
# }

# # 1. First, define the URL Map and Target Proxy for HTTP(S) L7 LB
# http_routing_configs = {
#   "my-regional-http-routing" = {
#     # FIXED: Changed from us-east4 to us-central1 to match the backend service
#     region      = "us-central1"
#     description = "URL map and proxy for web frontend"

#     # Points backward to your Backend Service
#     default_service = "projects/<proj-id>/regions/us-central1/backendServices/zonal-neg-backend-srv"
#   }
# }

# # 2. Or Define Target TCP Proxy for Regional TCP Proxy Load Balancers (Internal or External)
# tcp_routing_configs = {
#   "my-regional-tcp-proxy" = {
#     region          = "us-east4"
#     description     = "Target TCP proxy for cross-cloud hybrid NEG backend"
#     backend_service = "projects/<proj-id>/regions/us-east4/backendServices/hybrid-neg-backend-srv"
#   }
# }


# forwarding_rules = {

#   # Example 1: L4 Internal TCP Load Balancer
#   "l4-ilb-forwarding-rule" = {
#     region                = "us-central1"
#     description           = "Internal L4 Load Balancer for database cluster"
#     load_balancing_scheme = "INTERNAL"
#     network               = "projects/<proj-id>/global/networks/vpc-p-workload-01"
#     subnetwork            = "projects/<proj-id>/regions/us-central1/subnetworks/vpc-p-workload-01-sn-usc1"
#     ip_protocol           = "TCP"
#     ports                 = ["5432"]
#     allow_global_access   = true

#     # FIXED: Updated to point to the actual backend service you defined above
#     backend_service = "projects/<proj-id>/regions/us-central1/backendServices/mig-backend-srv"
#   }

#   # Example 2: L7 Internal HTTP Load Balancer
#   "l7-ilb-forwarding-rule" = {
#     region                = "us-central1"
#     description           = "Internal L7 Load Balancer for web frontend"
#     load_balancing_scheme = "INTERNAL_MANAGED"
#     network               = "projects/<proj-id>/global/networks/vpc-p-workload-01"
#     subnetwork            = "projects/<proj-id>/regions/us-central1/subnetworks/vpc-p-workload-01-sn-usc1"
#     ip_protocol           = "TCP"
#     port_range            = "80"

#     # FIXED: Pointed to the exact proxy name created by the http_routing_configs module
#     target = "projects/<proj-id>/regions/us-central1/targetHttpProxies/my-regional-http-routing-proxy"
#   }

# }

######################################################################################################################################################

health_checks = {
  # KEPT: Required for the backend service to know the VM is healthy on port 80
  "web-http-hc" = {
    description        = "Basic HTTP health check for web tier"
    region             = "us-central1"
    check_interval_sec = 10
    http_health_check = {
      port         = 80
      request_path = "/" # Update this to your actual health check path if different
    }
  }

  # --- COMMENTED OUT UNNEEDED HEALTH CHECKS ---
  # "db-tcp-hc" = { ... }
  # "secure-api-https-hc" = { ... }
  # "internal-grpc-hc" = { ... }
}

backend_services = {
  # --- COMMENTED OUT UNNEEDED BACKENDS ---
  # "mig-backend-srv" = { ... }

  # KEPT: The backend service that ties the health check and NEG together
  "zonal-neg-backend-srv" = {
    region                = "us-central1"
    description           = "Backend service for Zonal NEGs"
    load_balancing_scheme = "INTERNAL_MANAGED"
    protocol              = "HTTP"
    health_checks         = ["projects/<proj-id>/regions/us-central1/healthChecks/web-http-hc"]

    log_config = {
      enable      = true
      sample_rate = 0.5
    }

    backends = [
      {
        group                 = "projects/<proj-id>/zones/us-central1-a/networkEndpointGroups/my-populated-zonal-neg"
        balancing_mode        = "RATE"
        max_rate_per_endpoint = 50
        capacity_scaler       = 1.0
      }
    ]
  }

  # --- COMMENTED OUT UNNEEDED BACKENDS ---
  # "serverless-neg-backend-srv" = { ... }
}

# --- COMMENTED OUT ALL INSTANCE GROUPS (We are using NEGs instead) ---
# instance_groups = {
#   "web-unmanaged-ig" = { ... }
#   "db-unmanaged-ig" = { ... }
#   "api-backend-ig" = { ... }
# }

negs = {
  # KEPT: The Zonal NEG attaching your specific VM
  "my-populated-zonal-neg" = {
    network_endpoint_type = "GCE_VM_IP_PORT"
    description           = "Zonal NEG with attached VMs"
    network               = "projects/<proj-id>/global/networks/vpc-p-workload-01"
    subnetwork            = "projects/<proj-id>/regions/us-central1/subnetworks/vpc-p-workload-01-sn-usc1"
    zone                  = "us-central1-a"
    default_port          = 80

    endpoints = {
      "vm-01" = {
        instance   = "vpc-p-workload-01-vm01"
        ip_address = "10.1.1.100"
        port       = 80
      }
    }
  }

  # --- COMMENTED OUT UNNEEDED NEGS ---
  # "my-cloudrun-neg" = { ... }
  # "my-url-masked-cloudrun-neg" = { ... }
  # "my-cloudfunction-neg" = { ... }
}

http_routing_configs = {
  # KEPT: Required middleware for an L7 Application Load Balancer
  "my-regional-http-routing" = {
    region           = "us-central1"
    description      = "URL map and proxy for web frontend"
    default_service  = "projects/<proj-id>/regions/us-central1/backendServices/zonal-neg-backend-srv"
    ssl_certificates = ["projects/<proj-id>/regions/us-central1/sslCertificates/my-internal-lb-cert"]

    # NEW ADDITION: Enforce host-header routing matching your curl test
    hosts = ["internal-lb.example.com"]
  }
}

forwarding_rules = {
  # --- COMMENTED OUT L4 FORWARDING RULE ---
  # "l4-ilb-forwarding-rule" = { ... }

  # KEPT: The entry point for your L7 Internal Load Balancer
  "l7-ilb-forwarding-rule" = {
    region                = "us-central1"
    description           = "Internal L7 Load Balancer for web frontend"
    load_balancing_scheme = "INTERNAL_MANAGED"
    network               = "projects/<proj-id>/global/networks/vpc-p-workload-01"
    subnetwork            = "projects/<proj-id>/regions/us-central1/subnetworks/vpc-p-workload-01-sn-usc1"
    ip_protocol           = "TCP"
    port_range            = "443"
    target                = "projects/<proj-id>/regions/us-central1/targetHttpsProxies/my-regional-http-routing-proxy"
    //target = "projects/<proj-id>/regions/us-central1/targetHttpProxies/my-regional-http-routing-proxy"
    # Optional Resource Manager Tag Bindings: key => tag value id format
    # tag_bindings = {
    #   "tagKeys/281480126525795" = "tagValues/281477869187443"
    # }
  }
}


lb_traffic_extensions = {
  "dev-flex-gateway-modelarmor-extension" = {
    location              = "us-east4"
    project               = "cx-pr-ssvcs-security-01"
    load_balancing_scheme = "INTERNAL_MANAGED"
    forwarding_rules      = ["projects/cx-pr-ssvcs-security-01/regions/us-east4/forwardingRules/dev-flex-gateway-forwarding-rule"]
    extension_chains = [
      {
        name = "chain1"
        match_condition = {
          cel_expression = "request.host == \"dev.aigw.cxname.com\""
        }
        extensions = [
          {
            name             = "ext1"
            authority        = "modelarmor.googleapis.com"
            service          = "modelarmor.us-east4.rep.googleapis.com"
            fail_open        = false
            timeout          = "10s"
            supported_events = ["REQUEST_HEADERS", "REQUEST_BODY", "REQUEST_TRAILERS", "RESPONSE_HEADERS", "RESPONSE_BODY", "RESPONSE_TRAILERS"]
            metadata = {
              model_armor_settings = "[{\"model\":\"default\",\"model_response_template_id\":\"projects/cx-pr-ssvcs-security-01/locations/us-east4/templates/prj-cx-dev-pr-template-01\",\"user_prompt_template_id\":\"projects/cx-pr-ssvcs-security-01/locations/us-east4/locations/us-east4/templates/prj-cx-dev-pr-template-01\"}]"
            }
          }
        ]
      }
    ]
  }
}
