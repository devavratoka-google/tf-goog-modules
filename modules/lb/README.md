# Load Balancer Submodules Collection

This directory contains a modular collection of Google Cloud Platform Load Balancer submodules. These submodules allow you to compose regional Internal, External, HTTP, HTTPS, or TCP Load Balancers by declaring independent resources.

## Modules Available

1. **[Forwarding Rule](forwarding_rule/README.md)**: Configures a regional Google Compute Forwarding Rule targeting a backend service or target proxy.
2. **[HTTP Routing](http_routing/README.md)**: Configures regional HTTP/HTTPS routing resources (URL Map, Target HTTP/HTTPS Proxy).
3. **[Network Endpoint Group (NEG)](neg/README.md)**: Configures Zonal NEGs (for standard VM workloads) and Regional Serverless NEGs (for Cloud Run/Functions/App Engine).
4. **[Region Backend Service](region_backend_service/README.md)**: Configures a regional backend service with health checks and attached instances/NEGs.
5. **[Region Health Check](region_health_check/README.md)**: Configures regional health checks across TCP, HTTP, HTTPS, HTTP2, SSL, and gRPC protocols.
6. **[Unmanaged Instance Group (UMIG)](umig/README.md)**: Configures unmanaged instance groups to group statically declared VM instances.
7. **[LB Traffic Extension](lb_traffic_extension/README.md)**: Configures regional or global Load Balancer Traffic Extensions to customize headers and traffic processing.

Refer to each directory's respective `README.md` for specific inputs, outputs, and usage guidelines.
