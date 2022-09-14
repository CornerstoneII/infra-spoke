/*
  SECTION 1
*/

# Azure Resource Group Name
variable "sbx_ncus_net_name" {
  description = "SBX Resource Group Name"
  type        = string
  default     = "sbx-ncus-net-rg"
}
# Azure Resources Location
variable "sbx_ncus_net_location" {
  description = "Region in which Sbx Azure Resources are to be created"
  type        = string
  default     = "North Central US"
}


## SBX Virtual Network
variable "sbx_ncus_s_vnt" {
  description = "SBX Virtual Network name"
  type        = string
  default     = "sbx-ncus-s-vnt"
}
## SBX Virtual Network Address Space
variable "sbx_ncus_s_vnt_address_space" {
  description = "SBX Virtual Network address_space"
  type        = list(string)
  default     = ["172.0.3.0/24"]
}


# Virtual Machine Scale Set Subnet Name
variable "sbx_ncus_net_vmss_sn" {
  description = "Virtual Machine Scale Set Subnet Name"
  type        = string
  default     = "sbx-ncus-net-vmss-sn"
}
# Virtual Machine Scale Set Address Space
variable "sbx_ncus_net_vmss_sn_address" {
  description = "Virtual Machine Scale Set Subnet Address Spaces"
  type        = list(string)
  default     = ["172.0.3.32/27"]
}


# Key Vault registry Subnet Name
variable "sbx_ncus_net_kvt_sn" {
  description = "Virtual Machine Scale Set Subnet Name"
  type        = string
  default     = "sbx-ncus-net-kvt-sn"
}
# Key Vault registry Subnet Address Space
variable "sbx_ncus_net_kvt_sn_address" {
  description = "Virtual Machine Scale Set Address Spaces"
  type        = list(string)
  default     = ["172.0.3.0/27"]
}


# Load Balancer Subnet for VMSS Name
variable "sbx_ncus_net_lb_sn" {
  description = "Load Balancer Subnet for VMSS"
  type        = string
  default     = "sbx-ncus-net-lb-sn"
}
# Load Balancer Subnet for VMSS Address Space
variable "sbx_ncus_net_lb_sn_address" {
  description = "Key Vault registry Address Spaces"
  type        = list(string)
  default     = ["172.0.3.80/28"]
}


# Azure SQL Database Subnet Name
variable "sbx_ncus_net_db_sn" {
  description = "Azure SQL Database Subnet"
  type        = string
  default     = "sbx-ncus-net-db-sn"
}
# Azure SQL Database Subnet Address Space
variable "sbx_ncus_net_db_sn_address" {
  description = "Key Vault registry Address Spaces"
  type        = list(string)
  default     = ["172.0.3.64/28"]
}

/*
  SECTION 2
*/


variable "sbx_ncus_nsg_name" {
  description = "Sbx NSG Resource Group Name"
  type        = string
  default     = "sbx-ncus-nsg-rg"
}

variable "sbx_ncus_webapp_name" {
  description = "Sbx WebApp/VMSS Resource Group Name"
  type        = string
  default     = "sbx-ncus-webapp-rg"
}

variable "sbx_ncus_lb_name" {
  description = "Sbx Azure Load Balancer Resource Group Name"
  type        = string
  default     = "sbx-ncus-lb-rg"
}

variable "sbx_ncus_pep_name" {
  description = "Sbx Private Endpoint Resource Group Name"
  type        = string
  default     = "sbx-ncus-pep-rg"
}

variable "sbx_ncus_db_name" {
  description = "Sbx Azure SQL Resource Group Name"
  type        = string
  default     = "sbx-ncus-db-rg"
}



variable "sbx_ncus_kvt_name" {
  description = "Sbx Azure Key Vault Resource Group Name"
  type        = string
  default     = "sbx-ncus-kvt-rg"
}


variable "sbx_ncus_kvt_nsg" {
  description = "Sbx Azure Key Vault NSG Name"
  type        = string
  default     = "sbx-ncus-kvt-nsg"
}


variable "sbx_ncus_db_nsg" {
  description = "Sbx Azure DB NSG Name"
  type        = string
  default     = "sbx-ncus-db-nsg"
}


/*
  SECTION 3
*/

# NSG VARIABLES

# VARIABLE Sbx NSG
variable "sbx_ncus_vmss_nsg" {
  description = "Sbx NSG"
  type        = string
  default     = "sbx-ncus-vmss-nsg"
}


variable "web_linuxvm_instance_count" {
  description = "Number of VM"
  type        = number
  default     = 3
}


# Linux VM Input Variables Placeholder file.
variable "web_vmss_nsg_inbound_ports" {
  description = "Web VMSS NSG Inbound Ports"
  type        = list(string)
  default     = [22, 80, 443]
}
