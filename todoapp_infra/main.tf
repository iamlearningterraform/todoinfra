# create resource group for todoapp


module "resource_group" {
    source = "../modules/azurerm_resource_group"
    resource_group_name = "rg-todoapp"
    rg_location = "uksouth"
  
}

module "resource_group" {
    source = "../modules/azurerm_resource_group"
    resource_group_name = "rg-todoapp1"
    rg_location = "uksouth"
}

# create virtual network for infra


module "virtual_network" {
  depends_on = [ module.resource_group ]
  source = "../modules/azurerm_virtual_network"
  vnet_name = "vnet-todoapp"
  location = "uksouth"
  resource_group_name = "rg-todoapp"
  address_space = ["10.0.0.0/16"]

}


# create subnet for todoapp


module "frontend_subnet" {

    depends_on = [ module.virtual_network ]

    source = "../modules/azurerm_subnet"
    subnet_name = "frontend_subnet"
    resource_group_name = "rg-todoapp"
    vnet_name = "vnet-todoapp"
    address_prefixes = ["10.0.1.0/24"]
  
}

# create public ip for frontend vm

module "public_ip" {

    depends_on = [ module.resource_group ]

    source = "../modules/azurerm_public_ip"
    pip_name = "frontend_public_ip"
    resource_group_name = "rg-todoapp"
    location = "uksouth"
    allocation_method = "Static"
  
}



# create frontend vm




module "frontend_vm" {

    depends_on = [module.frontend_subnet, module.public_ip,module.key_vault,module.vm_username,module.vm_password]
    source = "../modules/azurerm_linux_virtual_machine"
    nic_name = "nic-vm-frontend"
    resource_group_name = "rg-todoapp"
    vm_name = "frontend-vm"
    pip_name = "frontend_public_ip"
    vm_size = "Standard_B1s"
    location = "uksouth"
    virtual_network_name = "vnet-todoapp"
    frontend_subnet_name = "frontend_subnet"
    image_publisher = "Canonical"
    image_offer = "0001-com-ubuntu-server-focal"
    image_sku = "20_04-lts"
    image_version = "latest"
    key_vault_name = "sonukitijori"
    username_secret_name = "vm-username"
    password_secret_name = "vm-password"

  
}


module "key_vault" {
    depends_on = [ module.resource_group ]
    source = "../modules/azurerm_key_vault"
    resource_group_name = "rg-todoapp"
    location = "uksouth"
    key_vault_name = "sonukitijori"
    sku_name = "standard"
  
}


module "vm_username" {

    depends_on = [ module.key_vault ]

    source = "../modules/azurerm_key_vault_secret"
    key_vault_name = "sonukitijori"
    resource_group_name = "rg-todoapp"
    secret_name = "vm-username"
    secret_value = "devopsadmin"
  
}



module "vm_password" {

    depends_on = [ module.key_vault ]

    source = "../modules/azurerm_key_vault_secret"
    key_vault_name = "sonukitijori"
    resource_group_name = "rg-todoapp"
    secret_name = "vm-password"
    secret_value = "Redhat@12345"
  
}



module "db_server_username" {

    depends_on = [ module.key_vault ]

    source = "../modules/azurerm_key_vault_secret"
    key_vault_name = "sonukitijori"
    resource_group_name = "rg-todoapp"
    secret_name = "dbusername1"
    secret_value = "devopsdbadmin"
  
}


module "db_server_password" {

    depends_on = [ module.key_vault ]

    source = "../modules/azurerm_key_vault_secret"
    key_vault_name = "sonukitijori"
    resource_group_name = "rg-todoapp"
    secret_name = "dbpassword1"
    secret_value = "Redhat@12345"
  
}



module "sql_server" {

    depends_on = [ module.resource_group,module.key_vault,module.db_server_username,module.db_server_password ]

    source = "../modules/azurerm_mssql_server"
    sql_server_name = "todoappdbserver4271"
    resource_group_name = "rg-todoapp"
    location = "uksouth"
    key_vault_name = "sonukitijori"
    sql_db_username = "dbusername1"
    sql_db_password = "dbpassword1"

    
  
}


module "sql_db" {

    depends_on = [ module.resource_group, module.sql_server ]

    source = "../modules/azurerm_mssql_database"
    sql_server_name = "todoappdbserver4271"
    resource_group_name = "rg-todoapp"
    sql_databse_name = "db001"
  
}