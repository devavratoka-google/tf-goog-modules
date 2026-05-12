module "region_health_checks" {
  source   = "./modules/lb/region_health_check"
  for_each = var.health_checks

  name                = each.key
  region              = each.value.region
  description         = each.value.description
  check_interval_sec  = each.value.check_interval_sec
  timeout_sec         = each.value.timeout_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold

  log_config         = each.value.log_config
  tcp_health_check   = each.value.tcp_health_check
  http_health_check  = each.value.http_health_check
  https_health_check = each.value.https_health_check
  http2_health_check = each.value.http2_health_check
  ssl_health_check   = each.value.ssl_health_check
  grpc_health_check  = each.value.grpc_health_check
}

module "region_backend_services" {
  source   = "./modules/lb/region_backend_service"
  for_each = var.backend_services

  name                            = each.key
  region                          = each.value.region
  description                     = each.value.description
  load_balancing_scheme           = each.value.load_balancing_scheme
  protocol                        = each.value.protocol
  port_name                       = each.value.port_name
  timeout_sec                     = each.value.timeout_sec
  connection_draining_timeout_sec = each.value.connection_draining_timeout_sec
  health_checks                   = each.value.health_checks
  enable_cdn                      = each.value.enable_cdn

  log_config = each.value.log_config
  backends   = each.value.backends
}

module "instance_groups" {
  source   = "./modules/lb/umig"
  for_each = var.instance_groups

  name        = each.key
  zone        = each.value.zone
  description = each.value.description
  network     = each.value.network
  instances   = each.value.instances
  named_ports = each.value.named_ports
}

module "negs" {
  source   = "./modules/lb/neg"
  for_each = var.negs

  name                  = each.key
  network_endpoint_type = each.value.network_endpoint_type
  description           = each.value.description
  network               = each.value.network
  subnetwork            = each.value.subnetwork

  zone         = each.value.zone
  default_port = each.value.default_port
  endpoints    = each.value.endpoints

  region         = each.value.region
  cloud_run      = each.value.cloud_run
  cloud_function = each.value.cloud_function
  app_engine     = each.value.app_engine
}

module "http_routing" {
  source   = "./modules/lb/http_routing"
  for_each = var.http_routing_configs

  depends_on = [module.region_backend_services]

  name            = each.key
  region          = each.value.region
  description     = each.value.description
  default_service = each.value.default_service
  hosts           = each.value.hosts

  ssl_certificates = each.value.ssl_certificates
}

module "forwarding_rules" {
  source   = "./modules/lb/forwarding_rule"
  for_each = var.forwarding_rules
  depends_on = [
    module.region_backend_services,
    module.http_routing
  ]

  name                  = each.key
  region                = each.value.region
  description           = each.value.description
  network               = each.value.network
  subnetwork            = each.value.subnetwork
  ip_address            = each.value.ip_address
  ip_protocol           = each.value.ip_protocol
  ports                 = each.value.ports
  port_range            = each.value.port_range
  backend_service       = each.value.backend_service
  target                = each.value.target
  load_balancing_scheme = each.value.load_balancing_scheme
  allow_global_access   = each.value.allow_global_access
  network_tier          = each.value.network_tier
  labels                = each.value.labels

  service_directory_registrations = each.value.service_directory_registrations
}

# 1. Generate a private key
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# 2. Generate a self-signed certificate using the key
resource "tls_self_signed_cert" "default" {
  private_key_pem = tls_private_key.default.private_key_pem

  subject {
    common_name  = "internal-lb.example.com"
    organization = "Demo"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# 3. Upload the generated cert and key to Google Cloud
resource "google_compute_region_ssl_certificate" "default" {
  name   = "my-internal-lb-cert"
  region = "us-central1"

  # Reference the generated values directly from memory, no files needed!
  private_key = tls_private_key.default.private_key_pem
  certificate = tls_self_signed_cert.default.cert_pem

  lifecycle {
    create_before_destroy = true
  }
}