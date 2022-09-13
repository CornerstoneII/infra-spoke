data "azurerm_client_config" "current" {}

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

  private_endpoint_network_policies_enabled = true
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



# Resource-10: Create a Key Vault
resource "azurerm_key_vault" "sbx_ncus_kvt" {
  name                        = "sbx-ncus-kvt0001"
  resource_group_name         = azurerm_resource_group.sbx_ncus_kvt_rg.name
  location                    = azurerm_resource_group.sbx_ncus_kvt_rg.location
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]
  }
}

resource "azurerm_key_vault_secret" "sbx_ncus_db_secret" {
  name         = "mssqlpassword"
  value        = azurerm_mysql_server.sbx_ncus_server.administrator_login_password
  key_vault_id = azurerm_key_vault.sbx_ncus_kvt.id
  depends_on   = [azurerm_key_vault.sbx_ncus_kvt]
}

# Creating Mysql server
resource "azurerm_mysql_server" "sbx_ncus_server" {
  name                = "mysqlserveradmin0001"
  location            = azurerm_resource_group.sbx_ncus_db_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_db_rg.name

  sku_name = "GP_Gen5_2"

  administrator_login               = "mysqlserveradmin"
  administrator_login_password      = "H@Sh1CoR3!"
  version                           = "8.0"
  ssl_enforcement_enabled           = true
  public_network_access_enabled     = false
  infrastructure_encryption_enabled = false
  auto_grow_enabled                 = true
}


resource "azurerm_mysql_database" "sbx_ncus_db" {
  name                = "sbx-ncus-db"
  resource_group_name = azurerm_resource_group.sbx_ncus_db_rg.name
  server_name         = azurerm_mysql_server.sbx_ncus_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  depends_on          = [azurerm_mysql_server.sbx_ncus_server]
}



# Resource-10: Create a Private Endpoint
resource "azurerm_private_endpoint" "sbx_ncus_kvt_pep" {
  name                = "sbx-ncus-kvt-pep"
  location            = azurerm_resource_group.sbx_ncus_pep_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_pep_rg.name
  subnet_id           = azurerm_subnet.sbx_ncus_net_kvt_sn.id

  private_service_connection {
    name                           = "sbx_ncus_kvt_psc"
    private_connection_resource_id = azurerm_mysql_server.sbx_ncus_server.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
  depends_on = [azurerm_mysql_server.sbx_ncus_server]
}
