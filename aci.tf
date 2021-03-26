provider "aci" {
  username    = var.aciUser
  #private_key = var.aciPrivateKey
  #cert_name   = var.aciCertName
  password = "cisco123"
  insecure    = true
  url         = var.aciUrl
}

#######################
### CREATION TENANT ###
#######################

resource "aci_tenant" "demo" {
  name        = var.tenantName
  description = "automated by terraform"
}

####################
### CREATION VRF ###
####################

resource "aci_vrf" "vrf1" {
  tenant_dn = aci_tenant.demo.id
  name      = "vrf1"
  pc_enf_pref            = "unenforced"
}

###################
### CREATION BD ###
###################

resource "aci_bridge_domain" "bd1" {
  tenant_dn                = aci_tenant.demo.id
  relation_fv_rs_ctx       = aci_vrf.vrf1.id
  #relation_fv_rs_bd_to_out = [data.aci_l3_outside.internet.id]
  name                     = "bd1"
}
resource "aci_bridge_domain" "bd2" {
  tenant_dn                = aci_tenant.demo.id
  relation_fv_rs_ctx       = aci_vrf.vrf1.id
  #relation_fv_rs_bd_to_out = [data.aci_l3_outside.internet.id]
  name                     = "bd2"
}

##########################
### CREATION BD SUBNET ###
##########################

resource "aci_subnet" "bd1_subnet" {
  parent_dn = aci_bridge_domain.bd1.id
  ip        = var.bd1Subnet
  scope     = ["shared"]
}

resource "aci_subnet" "bd2_subnet" {
  parent_dn = aci_bridge_domain.bd2.id
  ip        = var.bd2Subnet
  scope     = ["shared"]
}

####################################
### CREATION APPLICATION PROFILE ###
####################################

resource "aci_application_profile" "app1" {
  tenant_dn = aci_tenant.demo.id
  name      = "app1"
}

####################
### CREATION VMM ###
####################

data "aci_vmm_domain" "vds" {
  provider_profile_dn = var.provider_profile_dn
  name                = var.vmmDomain
}

#######################################
### CREATION EPG1 + ASSOCIATION VMM ###
#######################################

resource "aci_application_epg" "epg1" {
  application_profile_dn = aci_application_profile.app1.id
  name                   = "epg1"
  relation_fv_rs_bd      = aci_bridge_domain.bd1.id
  relation_fv_rs_cons    = [aci_contract.contract_epg1_epg2.id]
}

resource "aci_epg_to_domain" "vmmepg1" {

  application_epg_dn    = aci_application_epg.epg1.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}

#######################################
### CREATION EPG2 + ASSOCIATION VMM ###
#######################################

resource "aci_epg_to_domain" "vmmepg2" {

  application_epg_dn    = aci_application_epg.epg2.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}

resource "aci_application_epg" "epg2" {
  application_profile_dn = aci_application_profile.app1.id
  name                   = "epg2"
  relation_fv_rs_bd      = aci_bridge_domain.bd2.id
  relation_fv_rs_prov    = [aci_contract.contract_epg1_epg2.id]

}

#########################
### CREATION CONTRACT ###
#########################

resource "aci_contract" "contract_epg1_epg2" {
  tenant_dn = aci_tenant.demo.id
  name      = "Ping"
}

#################################
### CREATION CONTRACT SUBJECT ###
#################################

resource "aci_contract_subject" "Ping_subject1" {
  contract_dn                  = aci_contract.contract_epg1_epg2.id
  name                         = "Subject"
  relation_vz_rs_subj_filt_att = [aci_filter.allow_icmp.id]
}

################################
### CREATION CONTRACT FILTER ###
################################

resource "aci_filter" "allow_icmp" {
  tenant_dn = aci_tenant.demo.id
  name      = "allow_icmp"
}


resource "aci_filter_entry" "icmp" {
  name      = "icmp"
  filter_dn = aci_filter.allow_icmp.id
  ether_t   = "ip"
  prot      = "icmp"
  stateful  = "yes"
}

