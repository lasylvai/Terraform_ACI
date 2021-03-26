variable "vsphere_server" {
  default = "10.60.9.180"
}

variable "vsphere_user" {
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  default = "C$sco123"
}

variable "vsphere_datacenter" {
  default = "Datacenter"
}

variable "vsphere_datastore" {
  default = "ESX-5"
}

variable "vsphere_compute_cluster" {
  default = "esx-5.acifabric1.cisco.com"
}

variable "vsphere_template" {
  default = "ubuntu-1604-server-template"
}

variable "folder" {
  default = "Network-Centric"
}

variable "aci_vm1_name" {
  default = "ACI1-ACI"
}

variable "aci_vm2_name" {
  default = "ACI2-ACI"
}

variable "aci_vm1_address" {
  default = "10.200.0.20"
}

variable "aci_vm2_address" {
  default = "10.200.0.21"
}

variable "gateway" {
  default = "10.200.0.254"
}

variable "dns_list" {
  default = "10.9.15.1"
}

variable "dns_search" {
  default = "cisco.com"
}

variable "domain_name" {
  default = "cisco.com"
}
