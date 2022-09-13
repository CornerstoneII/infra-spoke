data "azurerm_client_config" "current" {}
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

  private_endpoint_network_policies_enabled = true
}

## Create GatewaySubnet
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = var.GatewaySubnet
  resource_group_name  = azurerm_resource_group.hub_ncus_net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_ncus_vnt.name
  address_prefixes     = var.GatewaySubnet_address

  private_endpoint_network_policies_enabled = true
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
resource "azurerm_subnet_network_security_group_association" "hub_ncus_mgt_nsg" {
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
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hub_ncus_nsg_rg.name
  network_security_group_name = azurerm_network_security_group.hub_ncus_mgt_nsg.name
}

# Resource-5: Create Public IP Address
resource "azurerm_public_ip" "hub_ncus_mgt_publicip" {
  name                = "hub-ncus-mgt-publicip"
  resource_group_name = azurerm_resource_group.hub_ncus_mgt_rg.name
  location            = azurerm_resource_group.hub_ncus_mgt_rg.location
  allocation_method   = "Static"
  tags = {
    environment = "Dev"
  }
}

# Resource-6: Create Network Interface
resource "azurerm_network_interface" "hub_ncus_mgt_nic" {
  name                = "hub-ncus-mgt-nic"
  location            = azurerm_resource_group.hub_ncus_mgt_rg.location
  resource_group_name = azurerm_resource_group.hub_ncus_mgt_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hub_ncus_net_mgt_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hub_ncus_mgt_publicip.id
  }
}


# Resource-8: Associate NSG and Linux VM NIC
resource "azurerm_network_interface_security_group_association" "vmnic_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.hub_ncus_mgt_nsg_inbound]
  network_interface_id      = azurerm_network_interface.hub_ncus_mgt_nic.id
  network_security_group_id = azurerm_network_security_group.hub_ncus_mgt_nsg.id
}

# Resource-10: Create a Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "hub_ncus_mgt" {
  name                = "hub-ncus-mgt"
  resource_group_name = azurerm_resource_group.hub_ncus_mgt_rg.name
  location            = azurerm_resource_group.hub_ncus_mgt_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.hub_ncus_mgt_nic.id,
  ]

  admin_password                  = "QWertyuiopasdfghjkl@123"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}





# Create Storage Account
resource "azurerm_storage_account" "hubncusstg" {
  name                = "hubncusstg"
  resource_group_name = azurerm_resource_group.hub_ncus_stg_rg.name
  location            = azurerm_resource_group.hub_ncus_stg_rg.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create Azure Storage Account Network Rules
resource "azurerm_storage_account_network_rules" "rules" {
  storage_account_id = azurerm_storage_account.hubncusstg.id
  default_action     = "Deny"
  bypass             = ["Metrics", "Logging", "AzureServices"]
}


# Resource-10: Create a Private Endpoint
resource "azurerm_private_endpoint" "hub_ncus_blob_pep" {
  name                = "hub-ncus-blob-pep"
  location            = azurerm_resource_group.hub_ncus_stg_pep_rg.location
  resource_group_name = azurerm_resource_group.hub_ncus_stg_pep_rg.name
  subnet_id           = azurerm_subnet.hub_ncus_net_mgt_sn.id
  private_service_connection {
    name                           = "hub_ncus_blob_psc"
    private_connection_resource_id = azurerm_storage_account.hubncusstg.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}


resource "azurerm_log_analytics_workspace" "hub_ncus_law" {
  name                = "hub-ncus-law"
  location            = azurerm_resource_group.hub_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.hub_ncus_net_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}



resource "azurerm_public_ip" "hub_ncus_gw_pip" {
  name                = "hub_ncus_gw_pip"
  location            = azurerm_resource_group.hub_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.hub_ncus_net_rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}


resource "azurerm_virtual_network_gateway" "hub_ncus_vpn_gw" {
  name                = "hub-ncus-gw"
  resource_group_name = azurerm_resource_group.hub_ncus_net_rg.name
  location            = azurerm_resource_group.hub_ncus_net_rg.location
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  active_active       = false
  generation          = "Generation1"
  # tags                = var.tags

  ip_configuration {
    name                          = "ipGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub_ncus_gw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.GatewaySubnet.id
  }
}
