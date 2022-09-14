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
# Create Network Security Group using Terraform Dynamic Blocks
resource "azurerm_network_security_group" "sbx_ncus_vmss_nsg" {
  name                = var.sbx_ncus_vmss_nsg
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_nsg_rg.name

  dynamic "security_rule" {
    for_each = var.web_vmss_nsg_inbound_ports
    content {
      name                       = "inbound-rule-${security_rule.key}"
      description                = "Inbound Rule ${security_rule.key}"
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}


# ***sbx-ncus-kvt-nsg***
resource "azurerm_network_security_group" "sbx_ncus_kvt_nsg" {
  name                = var.sbx_ncus_kvt_nsg
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_nsg_rg.name
}


# ***hub-ncus-db-nsg***
resource "azurerm_network_security_group" "sbx_ncus_db_nsg" {
  name                = var.sbx_ncus_db_nsg
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_nsg_rg.name
}


# Resource-1: Create Public IP Address for Azure Load Balancer

resource "azurerm_public_ip" "sbx_ncus_lb_publicip" {
  name                = "sbx-ncus-lb-publicip"
  resource_group_name = azurerm_resource_group.sbx_ncus_lb_rg.name
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}



# Resource-2: Create Azure Standard Load Balancer

resource "azurerm_lb" "sbx_ncus_lb" {
  name                = "sbx-ncus-lb"
  location            = azurerm_resource_group.sbx_ncus_net_rg.location
  resource_group_name = azurerm_resource_group.sbx_ncus_lb_rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "web-lb-fe-ip"
    public_ip_address_id = azurerm_public_ip.sbx_ncus_lb_publicip.id
  }
}


# Resource-3: Create LB Backend Pool

resource "azurerm_lb_backend_address_pool" "sbx_ncus_lb_backend_address_pool" {
  name            = "sbx_ncus_lb_backend"
  loadbalancer_id = azurerm_lb.sbx_ncus_lb.id
}


# Resource-4: Create LB Probe

resource "azurerm_lb_probe" "sbx_ncus_lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.sbx_ncus_lb.id
}


# Resource-5: Create LB Rule

resource "azurerm_lb_rule" "sbx_ncus_lb_rule" {

  name                           = "sbx_ncus_lb_rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.sbx_ncus_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = ["${azurerm_lb_backend_address_pool.sbx_ncus_lb_backend_address_pool.id}"]
  probe_id                       = azurerm_lb_probe.sbx_ncus_lb_probe.id
  loadbalancer_id                = azurerm_lb.sbx_ncus_lb.id
  depends_on                     = [azurerm_linux_virtual_machine_scale_set.sbx_ncus_vmss_webapp]
}



# Resource-8: Create a Linux Virtual Machine
resource "azurerm_linux_virtual_machine_scale_set" "sbx_ncus_vmss_webapp" {
  name                            = "sbx-ncus-vmss-webapp"
  resource_group_name             = azurerm_resource_group.sbx_ncus_webapp_rg.name
  location                        = azurerm_resource_group.sbx_ncus_webapp_rg.location
  instances                       = 3
  admin_username                  = "adminuser"
  sku                             = "Standard_DS1_v2"
  admin_password                  = "QWertyuiopasdfghjkl@123"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  upgrade_mode = "Automatic"

  network_interface {
    name                      = "sbx-ncus-vmss-nic"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.sbx_ncus_vmss_nsg.id
    ip_configuration {
      name                                   = "sbx-ncus-vmss-config"
      primary                                = true
      subnet_id                              = azurerm_subnet.sbx_ncus_net_lb_sn.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.sbx_ncus_lb_backend_address_pool.id]
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}




## ASSOCIATE NSG AND SUBNET

# ***sbx_ncus_net_kvt_sn***
resource "azurerm_subnet_network_security_group_association" "sbx_ncus_net_kvt_sn" {
  subnet_id                 = azurerm_subnet.sbx_ncus_net_kvt_sn.id
  network_security_group_id = azurerm_network_security_group.sbx_ncus_kvt_nsg.id
}


# ***sbx_ncus_net_db_sn***
resource "azurerm_subnet_network_security_group_association" "sbx_ncus_net_db_sn" {
  subnet_id                 = azurerm_subnet.sbx_ncus_net_db_sn.id
  network_security_group_id = azurerm_network_security_group.sbx_ncus_db_nsg.id
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
