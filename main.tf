# Terraform Settings Block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.20.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "hub-infra" {
  source = "./modules/hub-module"

}

module "spoke-infra" {
  source = "./modules/spoke-module"

}

module "other-infra" {
  source = "./modules/other-module"

}
