resource "azurerm_resource_group" "sbx_ncus_net_rg" {
  name     = var.sbx_ncus_net_name
  location = var.sbx_ncus_net_location
}

resource "azurerm_resource_group" "sbx_ncus_nsg_rg" {
  name     = var.sbx_ncus_nsg_name
  location = azurerm_resource_group.sbx_ncus_net_rg.location
}


resource "azurerm_resource_group" "sbx_ncus_webapp_rg" {
  name     = var.sbx_ncus_webapp_name
  location = azurerm_resource_group.sbx_ncus_net_rg.location
}


resource "azurerm_resource_group" "sbx_ncus_lb_rg" {
  name     = var.sbx_ncus_lb_name
  location = azurerm_resource_group.sbx_ncus_net_rg.location
}

resource "azurerm_resource_group" "sbx_ncus_pep_rg" {
  name     = var.sbx_ncus_pep_name
  location = azurerm_resource_group.sbx_ncus_net_rg.location
}

resource "azurerm_resource_group" "sbx_ncus_db_rg" {
  name     = var.sbx_ncus_db_name
  location = azurerm_resource_group.sbx_ncus_net_rg.location
}

resource "azurerm_resource_group" "sbx_ncus_kvt_rg" {
  name     = var.sbx_ncus_kvt_name
  location = azurerm_resource_group.sbx_ncus_net_rg.location
}


/*
  NSG CREATION
*/

## Create SBX Virtual Network
resource "azurerm_virtual_network" "sbx_ncus_s_vnt" {
  name                = var.sbx_ncus_s_vnt
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_net_rg.name
  address_space       = var.sbx_ncus_s_vnt_address_space
}


## Create Virtual Machine Scale Set Subnet
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


## CREATE Network Security Group (NSG)

# ***sbx_ncus_vmss_nsg***
resource "azurerm_network_security_group" "sbx_ncus_vmss_nsg" {
  name                = var.sbx_ncus_vmss_nsg
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_nsg_rg.name
}



## ASSOCIATE NSG AND SUBNET

# ***sbx_ncus_net_vmss_sn***
resource "azurerm_subnet_network_security_group_association" "sbx_ncus_net_vmss_sn" {
  # depends_on                = [azurerm_network_security_rule.sbx_ncus_vmss_nsg_inbound]
  subnet_id                 = azurerm_subnet.sbx_ncus_net_vmss_sn.id
  network_security_group_id = azurerm_network_security_group.sbx_ncus_vmss_nsg.id
}


# ***sbx_ncus_net_kvt_sn***
resource "azurerm_subnet_network_security_group_association" "sbx_ncus_net_kvt_sn" {
  # depends_on                = [azurerm_network_security_rule.sbx_ncus_vmss_nsg_inbound]
  subnet_id                 = azurerm_subnet.sbx_ncus_net_kvt_sn.id
  network_security_group_id = azurerm_network_security_group.sbx_ncus_vmss_nsg.id
}


# ***sbx_ncus_net_lb_sn***
resource "azurerm_subnet_network_security_group_association" "sbx_ncus_net_lb_sn" {
  # depends_on                = [azurerm_network_security_rule.sbx_ncus_vmss_nsg_inbound] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354
  subnet_id                 = azurerm_subnet.sbx_ncus_net_lb_sn.id
  network_security_group_id = azurerm_network_security_group.sbx_ncus_vmss_nsg.id
}


# ***sbx_ncus_net_db_sn***
resource "azurerm_subnet_network_security_group_association" "sbx_ncus_net_db_sn" {
  # depends_on                = [azurerm_network_security_rule.sbx_ncus_vmss_nsg_inbound] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354
  subnet_id                 = azurerm_subnet.sbx_ncus_net_db_sn.id
  network_security_group_id = azurerm_network_security_group.sbx_ncus_vmss_nsg.id
}


## CREATE NSG RULES

resource "azurerm_network_security_rule" "sbx_ncus_vmss_nsg_inbound" {
  name                        = "Inbound-Rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sbx_ncus_nsg_rg.name
  network_security_group_name = azurerm_network_security_group.sbx_ncus_vmss_nsg.name
}
