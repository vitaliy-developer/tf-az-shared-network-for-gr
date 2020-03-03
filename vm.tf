# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
    count                 = var.vm_count
    name                  = "${var.prefix}-virtual_machine-${count.index}"
    location              = var.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
    vm_size               = var.azurerm_virtual_machine_vm_size

    storage_image_reference {
      publisher = var.storage_image_reference_publisher
      offer     = var.storage_image_reference_offer
      sku       = var.storage_image_reference_sku
      version   = var.storage_image_reference_version
    }
    storage_os_disk {
      name              = "${var.storage_os_disk_name}-${count.index}"
      caching           = var.storage_os_disk_caching
      create_option     = var.storage_os_disk_create_option
      managed_disk_type = var.storage_os_disk_managed_disk_type
    }

    dynamic "storage_data_disk" {
      for_each = var.secondary_disks
      content {
        name              = "${storage_data_disk.value["name"]}-${count.index}"
        managed_disk_type = storage_data_disk.value["managed_disk_type"]
        create_option     = storage_data_disk.value["create_option"]
        lun               = storage_data_disk.value["lun"]
        disk_size_gb      = storage_data_disk.value["disk_size_gb"]
      }
    }
    os_profile {
      computer_name  = var.computer_name
      admin_username = var.admin_username
      admin_password = var.admin_password
    }
    os_profile_linux_config {
      disable_password_authentication = var.disable_password_authentication
    }
    tags = {
      environment = var.tags_linux_config
    }

    depends_on = [azurerm_network_interface.nic]
}

output "test" {
  value = azurerm_network_interface.nic.*.id
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    count                     = var.network_interface
    name                      = "${var.prefix}-nic-${count.index}"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.rg.name
    tags                      = var.tags

    ip_configuration {
        name                          = "${var.prefix}-nic"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = var.nic_private_ip_address_allocation
        public_ip_address_id          = azurerm_public_ip.publicip.id
    }
}

# # Create public IP
resource "azurerm_public_ip" "publicip" {
    name                         = "${var.prefix}-PublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = coalesce(var.allocation_method, var.public_ip_address_allocation, "Dynamic")
    tags                         = var.tags
}