variable "vpc_id" {}
variable "cluster_name" {}

variable "instance_group" {
  default = "default"
}

variable "allowed_inbound_cidr_blocks" {
  type    = "list"
  default = []
}

variable "allowed_inbound_security_group_ids" {
  type    = "list"
  default = []
}

variable "allowed_inbound_security_group_count" {
  default = 0
}

variable "server_rpc_port" {
  description = "The port used by servers to handle incoming requests from other agents."
  default     = 8300
}

variable "serf_lan_port" {
  description = "The port used to handle gossip in the LAN. Required by all agents."
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by servers to gossip over the WAN to other servers."
  default     = 8302
}

variable "cli_rpc_port" {
  description = "The port used by all agents to handle RPC from the CLI."
  default     = 8400
}

variable "http_api_port" {
  description = "The port used by clients to talk to the HTTP API"
  default     = 8500
}

variable "dns_port" {
  description = "The port used to resolve DNS queries."
  default     = 53
}
