# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.name}-vnet"
    address_space       = var.azurerm_virtual_network_address_space
    location            = var.location
    resource_group_name = azurerm_resource_group.rg_3.name
    tags                = var.tags
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.name}-subnet"
    resource_group_name  = azurerm_resource_group.rg_3.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = var.azurerm_subnet_address_prefix
}

# # # Create public IP
# resource "azurerm_public_ip" "publicip" {
#     name                         = "${var.prefix}-PublicIP"
#     location                     = var.location
#     resource_group_name          = azurerm_resource_group.rg_3.name
#     allocation_method            = coalesce(var.allocation_method, var.public_ip_address_allocation, "Dynamic")
#     tags                         = var.tags
# }

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.prefix}-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg_3.name
    tags                = var.tags
    security_rule  {
        name                       = var.security_group["name"]
        priority                   = var.security_group["priority"]
        direction                  = var.security_group["direction"]
        access                     = var.security_group["access"]
        protocol                   = var.security_group["protocol"]
        source_port_range          = var.security_group["source_port_range"]
        destination_port_range     = var.security_group["destination_port_range"]
        source_address_prefix      = var.security_group["source_address_prefix"]
        destination_address_prefix = var.security_group["destination_address_prefix"]
    }
}

# # Create network interface
# resource "azurerm_network_interface" "nic" {
#     count                     = var.network_interface
#     name                      = "${var.prefix}-nic-${count.index}"
#     location                  = var.location
#     resource_group_name       = azurerm_resource_group.rg_3.name
#     tags                      = var.tags

#     ip_configuration {
#         name                          = "${var.prefix}-nic"
#         subnet_id                     = azurerm_subnet.subnet.id
#         private_ip_address_allocation = var.nic_private_ip_address_allocation
#         public_ip_address_id          = length(azurerm_public_ip.publicip.*.id) > 0 ? element(concat(azurerm_public_ip.publicip.*.id, list("")), count.index) : ""
#     }
# }
