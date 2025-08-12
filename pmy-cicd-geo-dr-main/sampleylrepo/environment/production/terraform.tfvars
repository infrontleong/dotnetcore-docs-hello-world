location             = "east asia"
source_sea_resource_group_name = "rg-terraform-principal-sea-001"
source_ea_resource_group_name = "rg-terraform-principal-ea-002"
target_ea_resource_group_name  = "rg-terraform-principal-ea-003"

# ea vnet info
vnet_terraform_principal_ea_001_name = "vnet-terraform-principal-ea-001"
subnet_summer_ea_prod_app_new_name = "subnet-summer-ea-prod-app-new"
subnet_summer_ea_prod_web_new_name = "subnet-summer-ea-prod-web-new"
subnet_summer_ea_mgmt_new_name= "subnet-summer-ea-mgmt-new"


# vmss activities
lb_principal_test_name = "lb-principal-test"
lb_principal-test_backend_pool_name = "backendpool001"
keyvault_store_public_key_name = "keyvault-principal"
keyvault_secret_store_public_key_name = "publickeyprincipal"
vmss_azure_compute_galleries_name = "imagessummerrea001"
vmss_azure_compute_galleries_name_image_name = "linux-images"
vmss_ulsmrwebprod01_name = "ulsmrwebprod01"
vmss_ulsmrappprod01_name = "ulsmrappprod01"
vmss_ulsmrwebprod01_sku = "Standard_B2as_v2"
vmss_ulsmrappprod01_sku ="Standard_B2as_v2"
admin_username          = "azureuser2"
zones                   = ["1", "2", "3"]
tags = {
  Project = "Summer"
}

# restore vm activities
recoveyservicevault_rsv_terraform_principal_sea_001 = "rsv-terraform-principal-sea-001"

# failover storage account activities
storageaccountsea_strgprinpalsea001_name= "strgprinpalsea001"
storageaccountsea_stgprinciea_name = "stgprinciea"

# sql database activities
sqlserver_icqsqlserversea_name = "icqsqlserversea"
sqlserver_sqlserverleong_ea_001_name = "sqlserverleong-ea-001"
sqlserver_icqsqlserversea_resource_group_name = "250410-TEST-SQL-SEA-V0"
sqlserver_database_icqsqldb_name = "icqsqldb"


# Storage Account for Terraform backend
storage_account_store_tfstatefile_storage_account_name   = "stgprinciea"
storage_account_store_tfstatefile_container_name         = "container-principal-test-001"
storage_account_store_tfstatefile_tfstate_key            = "demoprincipal02.tfstate"
storage_account_store_tfstatefile_resource_group_name    = "rg-terraform-principal-ea-002"