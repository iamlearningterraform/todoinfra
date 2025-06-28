resource "azurerm_network_interface" "nic" {

    name = var.nic_name
    resource_group_name = var.resource_group_name
    location = var.location


    ip_configuration {
      name = "internal"
      private_ip_address_allocation = "Dynamic"
      subnet_id = data.azurerm_subnet.frontend_subnet.id
      public_ip_address_id = data.azurerm_public_ip.pip.id
    }

  
}


data "azurerm_public_ip" "pip" {
    name = var.pip_name
    resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "frontend_subnet" {

    name = var.frontend_subnet_name
    virtual_network_name = var.virtual_network_name
    resource_group_name = var.resource_group_name
  
}

data "azurerm_key_vault" "kv" {
  name = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "vm-username" {
  name= var.username_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "vm-password" {
  name= var.password_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_linux_virtual_machine" "frontend_vm" {
    name = var.vm_name
    location = var.location
    resource_group_name = var.resource_group_name
    size = var.vm_size
    network_interface_ids = [
        azurerm_network_interface.nic.id,
        ]
    admin_username = data.azurerm_key_vault_secret.vm-username.value
    admin_password = data.azurerm_key_vault_secret.vm-password.value
    disable_password_authentication = false


    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = var.image_publisher
      offer = var.image_offer
      sku = var.image_sku
      version = var.image_version
    }
  

 custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
  )



}