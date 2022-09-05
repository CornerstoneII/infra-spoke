resource "azurerm_resource_group" "sbx_ncus_net_rg" {
  name     = var.sbx_ncus_net_name
  location = var.sbx_ncus_net_location
}


## Create SBX Virtual Network
resource "azurerm_virtual_network" "sbx_ncus_s_vnt" {
  name                = var.sbx_ncus_s_vnt
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_net_rg.name
  address_space       = var.sbx_ncus_s_vnt_address_space
}


## Create Virtual Machine Scale Set

resource "azurerm_subnet" "sbx_ncus_net_vmss_sn" {
  name                 = var.sbx_ncus_net_vmss_sn
  resource_group_name  = azurerm_resource_group.sbx_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.sbx_ncus_s_vnt.name
  address_prefixes     = var.sbx_ncus_net_vmss_sn_address
}


## Create Key Vault registry Subnet

resource "azurerm_subnet" "sbx_ncus_net_kvt_sn" {
  name                 = var.sbx_ncus_net_kvt_sn
  resource_group_name  = azurerm_resource_group.sbx_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.sbx_ncus_s_vnt.name
  address_prefixes     = var.sbx_ncus_net_kvt_sn_address
}


## Create Load Balancer Subnet for VMSS Subnet

resource "azurerm_subnet" "sbx_ncus_net_lb_sn" {
  name                 = var.sbx_ncus_net_lb_sn
  resource_group_name  = azurerm_resource_group.sbx_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.sbx_ncus_s_vnt.name
  address_prefixes     = var.sbx_ncus_net_lb_sn_address
}


## Create Azure SQL Database Subnet

resource "azurerm_subnet" "sbx_ncus_net_db_sn" {
  name                 = var.sbx_ncus_net_db_sn
  resource_group_name  = azurerm_resource_group.sbx_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.sbx_ncus_s_vnt.name
  address_prefixes     = var.sbx_ncus_net_db_sn_address
}
