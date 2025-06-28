resource "azurerm_key_vault" "kv" {

    name = var.key_vault_name
    location = var.location
    sku_name = var.sku_name
    resource_group_name = var.resource_group_name
    tenant_id = data.azurerm_client_config.current.tenant_id


    access_policy {
        object_id = data.azurerm_client_config.current.object_id
        tenant_id = data.azurerm_client_config.current.tenant_id

        key_permissions = [
            "Get",
        ]

        secret_permissions = [
            "Get", "Set",
        ]

        storage_permissions = [
            "Get",
        ]
    }


  
}



data "azurerm_client_config" "current" {}


