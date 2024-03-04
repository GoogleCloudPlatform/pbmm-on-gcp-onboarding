variable srv_name {
  type = string
  description = "Name of the service to be created. It will be used as part of resource names."
}

variable targets {
  type = list(object({
    ip = string
    port = number
    mappedport = number
    }))
  description = "List of target IP and port tuples for creating DNATs on FortiGate."
}

variable logtraffic {
  type = string
  default = "all"
  description = "logtraffic value to relay to fortios_firewall_policy resource"
}

variable day0 {
  description = "Object containing all necessary data from day0 remote state. Common for all usecase modules."
}
