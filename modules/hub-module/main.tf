## Create Resource Group

resource "azurerm_resource_group" "hub_ncus_net_rg" {
  name     = var.hub_ncus_net_name
  location = var.hub_ncus_net_location
}


## Create Hub Virtual Network

resource "azurerm_virtual_network" "hub_ncus_vnt" {
  name                = var.hub_ncus_vnt
  location            = azurerm_resource_group.hub_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.hub_ncus_net_rg.name
  address_space       = var.hub_ncus_vnt_address_space
}


## Create Application Gateway Subnet

resource "azurerm_subnet" "hub_ncus_net_appgw_sn" {
  name                 = var.hub_ncus_net_appgw_sn
  resource_group_name  = azurerm_resource_group.hub_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_ncus_vnt.name
  address_prefixes     = var.hub_ncus_net_appgw_sn_address
}


## Create Management Tools Subnet

resource "azurerm_subnet" "hub_ncus_net_mgt_sn" {
  name                 = var.hub_ncus_net_mgt_sn
  resource_group_name  = azurerm_resource_group.hub_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_ncus_vnt.name
  address_prefixes     = var.hub_ncus_net_mgt_sn_address
}


## Create Storage Account Subnet

resource "azurerm_subnet" "hub_ncus_net_stg_sn" {
  name                 = var.hub_ncus_net_stg_sn
  resource_group_name  = azurerm_resource_group.hub_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_ncus_vnt.name
  address_prefixes     = var.hub_ncus_net_stg_sn_address
}


## Create GatewaySubnet Subnet

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = var.GatewaySubnet
  resource_group_name  = azurerm_resource_group.hub_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_ncus_vnt.name
  address_prefixes     = var.GatewaySubnet_address
}


## Create Log Analytics Subnet

resource "azurerm_subnet" "hub_ncus_net_mon_sn" {
  name                 = var.hub_ncus_net_mon_sn
  resource_group_name  = azurerm_resource_group.hub_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_ncus_vnt.name
  address_prefixes     = var.hub_ncus_net_mon_sn_address
}
