variable "security_group_id" {}

variable "port" {
    type = string
    default = "22"
}

variable "tcp_enabled" {
    type = list(bool)
    default = true
}

variable "udp_enabled" {
    type = list(bool)
    default = false
}

variable "inbound_cidr_blocks" {
    type = list(string)
    default = [
        "0.0.0.0/0"
    ]
}