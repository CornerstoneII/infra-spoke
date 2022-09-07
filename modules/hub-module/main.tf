/*
    CREATED RESOURCES:
    RG, VNET, SUBNET
*/

## Create Resource Group

resource "azurerm_resource_group" "hub_ncus_net_rg" {
  name     = var.hub_ncus_net_name
  location = var.hub_ncus_net_location
}

# CREATE Hub NSG Resource Group
resource "azurerm_resource_group" "hub_ncus_nsg_rg" {
  name     = var.hub_ncus_nsg_name
  location = azurerm_resource_group.hub_ncus_net_rg.location
}

# CREATE Mgt Tools VM Resource Group
resource "azurerm_resource_group" "hub_ncus_mgt_rg" {
  name     = var.hub_ncus_mgt_name
  location = azurerm_resource_group.hub_ncus_net_rg.location
}

# CREATE Blob Storage Account Resource Group
resource "azurerm_resource_group" "hub_ncus_stg_rg" {
  name     = var.hub_ncus_stg_name
  location = azurerm_resource_group.hub_ncus_net_rg.location
}

# CREATE VPN Gateway Resource Group
resource "azurerm_resource_group" "hub_ncus_gw_rg" {
  name     = var.hub_ncus_gw_name
  location = azurerm_resource_group.hub_ncus_net_rg.location
}

# Private Endpoint MON Resource Group
resource "azurerm_resource_group" "hub_ncus_mon_pep_rg" {
  name     = var.hub_ncus_mon_pep_name
  location = azurerm_resource_group.hub_ncus_net_rg.location
}

# CREATE Private Endpoint STG Resource Group
resource "azurerm_resource_group" "hub_ncus_stg_pep_rg" {
  name     = var.hub_ncus_stg_pep_name
  location = azurerm_resource_group.hub_ncus_net_rg.location
}

# CREATE Log Analytics STG Resource Group
resource "azurerm_resource_group" "hub_ncus_law_rg" {
  name     = var.hub_ncus_law_name
  location = azurerm_resource_group.hub_ncus_net_rg.location
}


/*
    SECTION 2:

*/
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

## Create GatewaySubnet
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



## CREATE Network Security Group (NSG)

# ***hub-ncus-appgw-nsg***
resource "azurerm_network_security_group" "hub_ncus_appgw_nsg" {
  name                = var.hub_ncus_appgw_nsg
  location            = azurerm_resource_group.hub_ncus_nsg_rg.location
  resource_group_name = azurerm_resource_group.hub_ncus_nsg_rg.name
}

# ***hub_ncus_mgt_nsg***
resource "azurerm_network_security_group" "hub_ncus_mgt_nsg" {
  name                = var.hub_ncus_mgt_nsg
  location            = azurerm_resource_group.hub_ncus_nsg_rg.location
  resource_group_name = azurerm_resource_group.hub_ncus_nsg_rg.name
}


## ASSOCIATE NSG AND SUBNET

# ***hub-ncus-appgw-nsg***
resource "azurerm_subnet_network_security_group_association" "hub-ncus-appgw-nsg" {
  # depends_on                = [azurerm_network_security_rule.hub_ncus_appgw_nsg_inbound]
  subnet_id                 = azurerm_subnet.hub_ncus_net_appgw_sn.id
  network_security_group_id = azurerm_network_security_group.hub_ncus_appgw_nsg.id
}


# ***hub-ncus-mgt-nsg***
resource "azurerm_subnet_network_security_group_association" "hub-ncus-mgt-nsg" {
  # depends_on                = [azurerm_network_security_rule.hub_ncus_mgt_nsg_inbound]
  subnet_id                 = azurerm_subnet.hub_ncus_net_mgt_sn.id
  network_security_group_id = azurerm_network_security_group.hub_ncus_mgt_nsg.id
}


# ***hub-ncus-net-mon_sn***
resource "azurerm_subnet_network_security_group_association" "hub_ncus_net_mon_sn" {
  # depends_on                = [azurerm_network_security_rule.hub_ncus_appgw_nsg_inbound]
  subnet_id                 = azurerm_subnet.hub_ncus_net_mon_sn.id
  network_security_group_id = azurerm_network_security_group.hub_ncus_appgw_nsg.id
}


# ***GatewaySubnet***
#


# ***hub_ncus_net_stg_sn***
resource "azurerm_subnet_network_security_group_association" "hub_ncus_net_stg_sn" {
  # depends_on                = [azurerm_network_security_rule.hub_ncus_appgw_nsg_inbound]
  subnet_id                 = azurerm_subnet.hub_ncus_net_stg_sn.id
  network_security_group_id = azurerm_network_security_group.hub_ncus_appgw_nsg.id
}


## CREATE NSG RULES

resource "azurerm_network_security_rule" "hub_ncus_appgw_nsg_inbound" {
  name                        = "Inbound-Rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hub_ncus_nsg_rg.name
  network_security_group_name = azurerm_network_security_group.hub_ncus_appgw_nsg.name
}

resource "azurerm_network_security_rule" "hub_ncus_mgt_nsg_inbound" {
  name                        = "Inbound-Rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hub_ncus_nsg_rg.name
  network_security_group_name = azurerm_network_security_group.hub_ncus_mgt_nsg.name
}
