variable "tenantName" {
  default = "Syl"
}

variable "aciUser" {
  default = "admin"
}

variable "aciPrivateKey" {
  default = "cisco123"
}

#variable "aciCertName" {
#  default = "ansible"
#}

variable "aciUrl" {
  default = "https://10.60.9.225"
}

variable "bd1Subnet" {
  type    = string
  default = "10.200.0.254/24"
}

variable "bd2Subnet" {
  type    = string
  default = "10.201.0.254/24"
}


variable "provider_profile_dn" {
  default = "uni/vmmp-VMware"
}

variable "vmmDomain" {
  default = "DVS_Domain"
}

# variable "l3OutName" {
#   default = "internet"
# }