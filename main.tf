# Configure the Microsoft Azure Provider.
terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group 1 vm
resource "azurerm_resource_group" "rg" {
    name     = "${var.prefix}resource-vm-1"
    location = var.location
    tags     = var.tags
}

# Create a resource group 2 vm
resource "azurerm_resource_group" "rg_2" {
    name     = "${var.prefix}resource-vm-2"
    location = var.location
    tags     = var.tags
}

# Create a resource group for networks
resource "azurerm_resource_group" "rg_3" {
    name     = "${var.prefix}resource-networks-3"
    location = var.location
    tags     = var.tags
}