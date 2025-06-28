resource "azurerm_key_vault_secret" "kvs" {
    name = var.secret_name
    value = var.secret_value
    key_vault_id = data.azurerm_key_vault.kv.id
  
}




data "azurerm_key_vault" "kv" {
   name = var.key_vault_name
   resource_group_name = var.resource_group_name
  
}



