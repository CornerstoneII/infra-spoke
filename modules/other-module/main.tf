resource "azurerm_resource_group" "hub_ncus_nsg_rg" {
  name     = var.hub_ncus_nsg_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "hub_ncus_mgt_rg" {
  name     = var.hub_ncus_mgt_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "hub_ncus_stg_rg" {
  name     = var.hub_ncus_stg_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "hub_ncus_gw_rg" {
  name     = var.hub_ncus_gw_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "hub_ncus_mon_pep_rg" {
  name     = var.hub_ncus_mon_pep_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "hub_ncus_stg_pep_rg" {
  name     = var.hub_ncus_stg_pep_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "hub_ncus_law_rg" {
  name     = var.hub_ncus_law_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "sbx_ncus_nsg_rg" {
  name     = var.sbx_ncus_nsg_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "sbx_ncus_webapp_rg" {
  name     = var.sbx_ncus_webapp_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "sbx_ncus_lb_rg" {
  name     = var.sbx_ncus_lb_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "sbx_ncus_pep_rg" {
  name     = var.sbx_ncus_pep_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "sbx_ncus_db_rg" {
  name     = var.sbx_ncus_db_name
  location = var.resource_group_location
}


resource "azurerm_resource_group" "sbx_ncus_kvt_rg" {
  name     = var.sbx_ncus_kvt_name
  location = var.resource_group_location
}
