variable "vpc_id" {}
variable "prefix" {}
variable "identifier" {}

variable "port_mappings" {
    type = map(object)
    default = {
        "22" = {
            tcp_enabled = true,
            udp_enabled = false,
        }
    }
}