resource "azurerm_subnet" "frontend_subnet" {

    name = var.subnet_name
    resource_group_name = var.resource_group_name
    virtual_network_name = var.vnet_name
    address_prefixes = var.address_prefixes

  
}


