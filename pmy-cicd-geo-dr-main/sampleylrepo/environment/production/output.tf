output "script_variable_source_sea_resource_group_name" { value = var.source_sea_resource_group_name}
output "script_variable_source_ea_resource_group_name" { value = var.source_ea_resource_group_name }
output "script_variable_target_ea_resource_group_name" {
    value = var.target_ea_resource_group_name
}
output "script_variable_recoveyservicevault_source_rsv_terraform_principal_sea_001" {
    value = var.recoveyservicevault_rsv_terraform_principal_sea_001
}


output "script_variable_storage_account_stgprinciea_id" {
    value = data.azurerm_storage_account.stgprinciea.id
}
output "script_variable_storageaccountsea_strgprinpalsea001_name" {
    value = var.storageaccountsea_strgprinpalsea001_name
}


//sql

output "script_variable_sqlserver_icqsqlserversea_name" {
    value = var.sqlserver_icqsqlserversea_name
}
output "script_variable_sqlserver_sqlserverleong_ea_001_name" {
    value = var.sqlserver_sqlserverleong_ea_001_name
}
output "script_variable_sqlserver_database_icqsqldb_name" {
    value = var.sqlserver_database_icqsqldb_name
}
output "script_variable_sqlserver_icqsqlserversea_resource_group_name" {
    value = var.sqlserver_icqsqlserversea_resource_group_name
}


//vnet, subnet
output "script_variable_subnet_summer_ea_mgmt_new_name" {
    value = var.subnet_summer_ea_mgmt_new_name
}
output "script_variable_vnet_terraform_principal_ea_001_name" {
    value = var.vnet_terraform_principal_ea_001_name
}

