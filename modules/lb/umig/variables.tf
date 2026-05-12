variable "name" {
  type = string
}
variable "zone" {
  type = string
}
variable "description" {
  type    = string
  default = null
}
variable "network" {
  type    = string
  default = null
}
variable "instances" {
  type    = set(string)
  default = []
}

variable "named_ports" {
  description = "List of named ports to map name to a port number"
  type = list(object({
    name = string
    port = number
  }))
  default = []
}