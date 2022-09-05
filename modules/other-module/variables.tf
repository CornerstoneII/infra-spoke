# Azure Resource Group Name
variable "hub_ncus_nsg_name" {
  description = "Hub NSG Resource Group Name"
  type        = string
  default     = "hub-ncus-nsg-rg"
}

variable "hub_ncus_mgt_name" {
  description = "Hub Mgt Tools VM Resource Group Name"
  type        = string
  default     = "hub-ncus-mgt-rg"
}


variable "hub_ncus_stg_name" {
  description = "Hub Blob Storage Account Resource Group Name"
  type        = string
  default     = "hub-ncus-stg-rg"
}

variable "hub_ncus_gw_name" {
  description = "Hub VPN Gateway Resource Group Name"
  type        = string
  default     = "hub-ncus-gw-rg"
}

variable "hub_ncus_mon_pep_name" {
  description = "Hub Private Endpoint MON Resource Group Name"
  type        = string
  default     = "hub-ncus-mon-pep-rg"
}

variable "hub_ncus_stg_pep_name" {
  description = "Hub Private Endpoint STG Resource Group Name"
  type        = string
  default     = "hub-ncus-stg-pep-rg"
}

variable "hub_ncus_law_name" {
  description = "Hub Log Analytics STG Resource Group Name"
  type        = string
  default     = "hub-ncus-law-rg"
}

variable "sbx_ncus_nsg_name" {
  description = "Sbx NSG Resource Group Name"
  type        = string
  default     = "sbx-ncus-nsg-rg"
}

variable "sbx_ncus_webapp_name" {
  description = "Sbx WebApp Resource Group Name"
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


# Azure Resources Location
variable "resource_group_location" {
  description = "Region in which Hub Azure Resources are to be created"
  type        = string
  default     = "North Central US"
}
