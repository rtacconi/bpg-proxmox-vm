variable "cluster" {
  description = "Configuration for the cluster"
  type = object({
    nodes = list(object({
      node = string
    }))
    cluster_name = string
  })
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = []
}

variable "bridge" {
  description = "Network bridge name"
  type        = string
  default     = "vmbr0"
}