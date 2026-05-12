variable "health_checks" {
  description = "A map of health checks to create via the child module."
  type = map(object({
    description         = optional(string)
    region              = string
    check_interval_sec  = optional(number, 5)
    timeout_sec         = optional(number, 5)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 2)

    log_config = optional(object({
      enable = optional(bool, false)
    }))

    tcp_health_check = optional(object({
      port               = optional(number)
      port_specification = optional(string)
      port_name          = optional(string)
      request            = optional(string)
      response           = optional(string)
      proxy_header       = optional(string)
    }))

    http_health_check = optional(object({
      port               = optional(number)
      port_specification = optional(string)
      port_name          = optional(string)
      host               = optional(string)
      request_path       = optional(string)
      response           = optional(string)
      proxy_header       = optional(string)
    }))

    https_health_check = optional(object({
      port               = optional(number)
      port_specification = optional(string)
      port_name          = optional(string)
      host               = optional(string)
      request_path       = optional(string)
      response           = optional(string)
      proxy_header       = optional(string)
    }))

    http2_health_check = optional(object({
      port               = optional(number)
      port_specification = optional(string)
      port_name          = optional(string)
      host               = optional(string)
      request_path       = optional(string)
      response           = optional(string)
      proxy_header       = optional(string)
    }))

    ssl_health_check = optional(object({
      port               = optional(number)
      port_specification = optional(string)
      port_name          = optional(string)
      request            = optional(string)
      response           = optional(string)
      proxy_header       = optional(string)
    }))

    grpc_health_check = optional(object({
      port               = optional(number)
      port_specification = optional(string)
      port_name          = optional(string)
      grpc_service_name  = optional(string)
    }))
  }))
  default = {}
}

variable "backend_services" {
  description = "A map of region backend services to create."
  type = map(object({
    region                          = string
    description                     = optional(string)
    load_balancing_scheme           = optional(string, "INTERNAL_MANAGED")
    protocol                        = optional(string, "HTTP")
    port_name                       = optional(string, "http")
    timeout_sec                     = optional(number, 30)
    connection_draining_timeout_sec = optional(number, 0)
    health_checks                   = optional(list(string), [])
    enable_cdn                      = optional(bool, false)

    log_config = optional(object({
      enable      = optional(bool, false)
      sample_rate = optional(number, 1.0)
    }))

    backends = optional(list(object({
      group                        = string
      balancing_mode               = optional(string)
      capacity_scaler              = optional(number)
      description                  = optional(string)
      failover                     = optional(bool)
      max_connections              = optional(number)
      max_connections_per_endpoint = optional(number)
      max_connections_per_instance = optional(number)
      max_rate                     = optional(number)
      max_rate_per_endpoint        = optional(number)
      max_rate_per_instance        = optional(number)
      max_utilization              = optional(number)
    })), [])
  }))
  default = {}
}

variable "instance_groups" {
  description = "A map of unmanaged instance groups to create."
  type = map(object({
    zone        = string
    description = optional(string)
    network     = optional(string)
    instances   = optional(set(string), [])

    named_ports = optional(list(object({
      name = string
      port = number
    })), [])
  }))
  default = {}
}

variable "negs" {
  description = "A map of Network Endpoint Groups to create (both Zonal and Serverless)."
  type = map(object({
    network_endpoint_type = optional(string, "GCE_VM_IP_PORT")
    description           = optional(string)
    network               = optional(string)
    subnetwork            = optional(string)

    zone         = optional(string)
    default_port = optional(number)

    region = optional(string)

    cloud_run = optional(object({
      service  = optional(string)
      tag      = optional(string)
      url_mask = optional(string)
    }))

    cloud_function = optional(object({
      function = optional(string)
      url_mask = optional(string)
    }))

    app_engine = optional(object({
      service  = optional(string)
      version  = optional(string)
      url_mask = optional(string)
    }))

    endpoints = optional(map(object({
      instance   = string
      ip_address = string
      port       = number
    })), {})
  }))
  default = {}
}

variable "http_routing_configs" {
  description = "A map of URL maps and Target Proxies to create."
  type = map(object({
    region          = string
    description     = optional(string)
    default_service = string
    hosts           = optional(list(string), [])
    //Optional list of certificate self-links. Defaults to empty list for HTTP.
    ssl_certificates = optional(list(string), [])
  }))
  default = {}
}

variable "forwarding_rules" {
  description = "A map of regional forwarding rules to create."
  type = map(object({
    region                = string
    description           = optional(string)
    network               = optional(string)
    subnetwork            = optional(string)
    ip_address            = optional(string)
    ip_protocol           = optional(string)
    ports                 = optional(list(string), [])
    port_range            = optional(string)
    backend_service       = optional(string)
    target                = optional(string)
    load_balancing_scheme = optional(string, "INTERNAL")
    allow_global_access   = optional(bool)
    network_tier          = optional(string)
    labels                = optional(map(string), {})

    service_directory_registrations = optional(object({
      namespace = optional(string)
      service   = optional(string)
    }))
  }))
  default = {}
}