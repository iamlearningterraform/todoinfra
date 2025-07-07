resource "azurerm_mssql_server" "db_server" {

    name = var.sql_server_name
    resource_group_name = var.resource_group_name
    location = var.location
    version                      = "12.0"
    administrator_login          = data.azurerm_key_vault_secret.db_username.value
    administrator_login_password = data.azurerm_key_vault_secret.db_password.value
    minimum_tls_version          = "1.2"

  
}



data "azurerm_key_vault" "kv" {
    name = var.key_vault_name
    resource_group_name = var.resource_group_name
}



data "azurerm_key_vault_secret" "db_username" {

    key_vault_id = data.azurerm_key_vault.kv.id
    name = var.sql_db_username

  
}

data "azurerm_key_vault_secret" "db_password" {

    key_vault_id = data.azurerm_key_vault.kv.id
    name = var.sql_db_password

  
}
