variable "name" {
  type        = string
  description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035."
}

variable "description" {
  type        = string
  description = "An optional description of this resource."
}

variable "labels" {
  type        = map(string)
  description = "Labels"
}

variable "ip_version" {
  type        = string
  description = "The IP Version that will be used by this address. The default value is IPV4. Possible values are: IPV4, IPV6."
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "network" {
  type        = string
  description = "The URL of the network in which to reserve the IP range. The IP range must be in RFC1918 space. The network cannot be deleted if there are any reserved IP ranges referring to it. This should only be set when using an Internal address."
}

variable "address" {
  type        = string
  description = "The IP address or beginning of the address range represented by this resource. This can be supplied as an input to reserve a specific address or omitted to allow GCP to choose a valid one for you."
}

variable "prefix_length" {
  type        = number
  description = "The prefix length of the IP range. If not present, it means the address field is a single IP address. This field is not applicable to addresses with addressType=INTERNAL when purpose=PRIVATE_SERVICE_CONNECT"
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. Possible values include: VPC_PEERING or PRIVATE_SERVICE_CONNECT"
}

variable "address_type" {
  type        = string
  description = "The type of the address to reserve. Default value is EXTERNAL. Possible values are: EXTERNAL, INTERNAL."
}