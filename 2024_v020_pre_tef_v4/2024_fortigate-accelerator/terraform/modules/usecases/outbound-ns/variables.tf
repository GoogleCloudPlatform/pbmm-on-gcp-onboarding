variable name {
  type = string
  description = "Name of the NAT to be created. It will be used as part of resource names."
  default = "nat"
}

variable day0 {
  description = "Object containing all necessary data from day0 remote state. Common for all usecase modules."
}

variable elb {
  description = "URL of network load balancer forwarding rule to be used for natting"
}

variable srcaddr {
  type = string
  default = "all"
  description = "Source address object name"
}

variable dstaddr {
  type = string
  default = "all"
  description = "Destination address object name"
}

variable service {
  type = string
  default = "ALL"
  description = "Destination service object name"
}

variable schedule {
  type = string
  default = "always"
  description = "FortiGate schedule object reference"
}

variable application_list {
  type = string
  default = "default"
  description = "FortiGate application filter profile reference"
}

variable av_profile {
  type = string
  default = "default"
  description = "FortiGate AV profile reference"
}

variable ips_sensor {
  type = string
  default = "default"
  description = "FortiGate IPS profile reference"
}

variable webfilter_profile {
  type = string
  default = "default"
  description = "FortiGate Webfilter profile reference"
}

variable ssl_ssh_profile {
  type = string
  default = "certificate-inspection"
  description = "FortiGate SSL profile reference"
}

variable logtraffic {
  type = string
  default = "all"
  description = "FortiGate traffic log settings"
}
