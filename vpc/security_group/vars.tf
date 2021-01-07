variable "vpc_id" {}
variable "prefix" {}
variable "identifier" {}

variable "port_mappings" {
    type = map(object({
        tcp_enabled = bool,
        udp_enabled = bool,
    }))
    default = {
        "22" = {
            tcp_enabled = true,
            udp_enabled = false,
        }
    }
}