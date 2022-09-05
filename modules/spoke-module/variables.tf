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
