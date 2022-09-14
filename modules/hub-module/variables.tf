## Azure Resource Group Name
variable "hub_ncus_net_name" {
  description = "Hub Resource Group Name"
  type        = string
  default     = "hub-ncus-net-rg"
}
## Azure Resources Location
variable "hub_ncus_net_location" {
  description = "Region in which Hub Azure Resources are to be created"
  type        = string
  default     = "North Central US"
}


## Hub Virtual Network
variable "hub_ncus_vnt" {
  description = "Hub Virtual Network name"
  type        = string
  default     = "hub-ncus-vnt"
}
## Hub Virtual Network Address Space
variable "hub_ncus_vnt_address_space" {
  description = "Hub Virtual Network address_space"
  type        = list(string)
  default     = ["172.0.0.0/23"]
}


# Application Gateway Subnet Name
variable "hub_ncus_net_appgw_sn" {
  description = "Application Gateway Subnet Name"
  type        = string
  default     = "hub-ncus-net-appgw-sn"
}
# Application Gateway Address Space
variable "hub_ncus_net_appgw_sn_address" {
  description = "Application Gateway Subnet Name Subnet Address Spaces"
  type        = list(string)
  default     = ["172.0.0.128/26"]
}


# Management Tools Subnet Name
variable "hub_ncus_net_mgt_sn" {
  description = "Management Tools Subnet Name"
  type        = string
  default     = "hub-ncus-net-mgt-sn"
}
# Management Tools Subnet Address Spaces
variable "hub_ncus_net_mgt_sn_address" {
  description = "Management Tools Subnet Address Spaces"
  type        = list(string)
  default     = ["172.0.0.192/27"]
}


# Storage Account Subnet Name
variable "hub_ncus_net_stg_sn" {
  description = "Storage Account Subnet Name"
  type        = string
  default     = "hub-ncus-net-stg-sn"
}
# Storage Account Address Space
variable "hub_ncus_net_stg_sn_address" {
  description = "Storage Account Subnet Address Spaces"
  type        = list(string)
  default     = ["172.0.0.64/26"]
}


# GatewaySubnet Subnet Name
variable "GatewaySubnet" {
  description = "GatewaySubnet Name"
  type        = string
  default     = "GatewaySubnet"
}
# GatewaySubnet Address Space
variable "GatewaySubnet_address" {
  description = "GatewaySubnet Address Spaces"
  type        = list(string)
  default     = ["172.0.0.0/26"]
}


# Log Analytics Subnet Name
variable "hub_ncus_net_mon_sn" {
  description = "Log Analytics Subnet Name"
  type        = string
  default     = "hub-ncus-net-mon-sn001"
}
# Log Analytics Address Space
variable "hub_ncus_net_mon_sn_address" {
  description = "Log Analytics Address Spaces"
  type        = list(string)
  default     = ["172.0.0.224/27"]
}




# Hub NSG Resource Group Name
variable "hub_ncus_nsg_name" {
  description = "Hub NSG Resource Group Name"
  type        = string
  default     = "hub-ncus-nsg-rg"
}
# Hub Mgt Tools VM Resource Group Name
variable "hub_ncus_mgt_name" {
  description = "Hub Mgt Tools VM Resource Group Name"
  type        = string
  default     = "hub-ncus-mgt-rg"
}

# Hub Blob Storage Account Resource Group Name
variable "hub_ncus_stg_name" {
  description = "Hub Blob Storage Account Resource Group Name"
  type        = string
  default     = "hub-ncus-stg-rg"
}
# Hub VPN Gateway Resource Group Name
variable "hub_ncus_gw_name" {
  description = "Hub VPN Gateway Resource Group Name"
  type        = string
  default     = "hub-ncus-gw-rg"
}

# Hub Private Endpoint MON Resource Group Name
variable "hub_ncus_mon_pep_name" {
  description = "Hub Private Endpoint MON Resource Group Name"
  type        = string
  default     = "hub-ncus-mon-pep-rg"
}
# Hub Private Endpoint STG Resource Group Name
variable "hub_ncus_stg_pep_name" {
  description = "Hub Private Endpoint STG Resource Group Name"
  type        = string
  default     = "hub-ncus-stg-pep-rg"
}

# Hub Log Analytics STG Resource Group Name
variable "hub_ncus_law_name" {
  description = "Hub Log Analytics STG Resource Group Name"
  type        = string
  default     = "hub-ncus-law-rg"
}




# NSG VARIABLES

# VARIABLE Application Gateway NSG
variable "hub_ncus_appgw_nsg" {
  description = "Application Gateway NSG"
  type        = string
  default     = "hub-ncus-appgw-nsg"
}


# VARIABLE Management Tools NSG
variable "hub_ncus_mgt_nsg" {
  description = "Management Tools NSG"
  type        = string
  default     = "hub-ncus-mgt-nsg"
}


# VARIABLE VPN Gateway
variable "hub-ncus-gw" {
  description = "VPN Gateway"
  type        = string
  default     = "hub-ncus-gw"
}
