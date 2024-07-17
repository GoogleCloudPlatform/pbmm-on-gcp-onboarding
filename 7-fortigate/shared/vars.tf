# GCP region
variable "region" {
  type    = string
  default = "northamerica-northeast1" #Default Region
}

# TODO Zone b is an arbitrary selection
# GCP zone
variable "zone" {
  type    = string
  default = "northamerica-northeast1-b"
}

# populate from auto vars
variable "remote_state_bucket" {
  type    = string
  default = "<bucket name here>"
}

# GCP Fortinet official project
variable "ftntproject" {
  type    = string
  default = "fortigcp-project-001"
}

# FortiGate Image name
# 7.4.3 x86 payg is projects/fortigcp-project-001/global/images/fortinet-fgtondemand-743-20240208-001-w-license
# 7.4.3 x86 byol is projects/fortigcp-project-001/global/images/fortinet-fgt-743-20240208-001-w-license
# 7.4.3 arm payg is projects/fortigcp-project-001/global/images/fortinet-fgtondemand-arm64-743-20240208-001-w-license
# 7.4.3 arm byol is projects/fortigcp-project-001/global/images/fortinet-fgt-arm64-743-20240208-001-w-license

variable "image" {
  type    = string
  default = "projects/fortigcp-project-001/global/images/fortinet-fgtondemand-743-20240208-001-w-license"
}

# GCP VNIC type
# either GVNIC or VIRTIO_NET
# ARM must use GVNIC
variable "nictype" {
  type    = string
  default = "GVNIC"
}
# GCP instance machine type
# ARM platform needs to use t2a-standard-4
# x86 can uses n1-standard-4
variable "machine" {
  type    = string
  default = "n1-standard-4"
}

# prj-net-hub-base
# vpc-c-shared-base-hub primary subnet
variable "hub_base_subnet" {
  type    = string
  default = "10.0.0.0/18"
}

# Fortigate additions begin
variable "hub_base_subnet_for_route" {
  type    = string
  default = "10.0.0.0/16"
}

variable "hub_base_subnet_for_port2" {
  type    = string
  default = "10.0.0.0"
}

variable "public_subnet_for_port1" {
  type    = string
  default = "172.16.0.0"
}
# Fortigate additions end

# prj-d-bu1--b-p1
# vpc-d-peering-base primary subnet
variable "peering_base_subnet" {
  type    = string
  default = "10.3.64.0/18"
}

# Public Subnet CIDR
variable "public_subnet" {
  type    = string
  default = "172.16.0.0/24"
}

# HA Subnet CIDR
variable "sync_subnet" {
  type    = string
  default = "172.16.2.0/24"
}
# MGMT Subnet CIDR
variable "mgmt_subnet" {
  type    = string
  default = "172.16.3.0/24"
}
# license file for active
variable "licenseFile" {
  type    = string
  default = "license1.lic"
}
# license file for passive
variable "licenseFile2" {
  type    = string
  default = "license2.lic"
}

# mgmt gateway ip, depends on your mgmt subnet cidr
variable "mgmt_gateway" {
  type    = string
  default = "172.16.3.1"
}
variable "mgmt_mask" {
  type    = string
  default = "255.255.255.0"
}

# active interface ip assignments
# active ext
variable "active_port1_ip" {
  type    = string
  default = "172.16.0.3"
}
variable "active_port1_mask" {
  type    = string
  default = "32"
}
# active int
variable "active_port2_ip" {
  type    = string
  default = "172.16.1.3"
}
variable "active_port2_mask" {
  type    = string
  default = "32"
}
# active sync
variable "active_port3_ip" {
  type    = string
  default = "172.16.2.3"
}
variable "active_port3_mask" {
  type    = string
  default = "32"
}
# active mgmt
variable "active_port4_ip" {
  type    = string
  default = "172.16.3.3"
}
variable "active_port4_mask" {
  type    = string
  default = "32"
}


# passive sync interface ip assignments
#passive ext
variable "passive_port1_ip" {
  type    = string
  default = "172.16.0.4"
}
variable "passive_port1_mask" {
  type    = string
  default = "32"
}

# passive int
variable "passive_port2_ip" {
  type    = string
  default = "172.16.1.4"
}
variable "passive_port2_mask" {
  type    = string
  default = "32"
}


# passive sync
variable "passive_port3_ip" {
  type    = string
  default = "172.16.2.4"
}
variable "passive_port3_mask" {
  type    = string
  default = "32"
}


# passive mgmt
variable "passive_port4_ip" {
  type    = string
  default = "172.16.3.4"
}
variable "passive_port4_mask" {
  type    = string
  default = "32"
}
