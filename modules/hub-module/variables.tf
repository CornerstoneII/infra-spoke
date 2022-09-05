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
  default     = "hub-ncus-net-mon-sn"
}

# Log Analytics Address Space
variable "hub_ncus_net_mon_sn_address" {
  description = "Log Analytics Address Spaces"
  type        = list(string)
  default     = ["172.0.0.224/27"]
}
