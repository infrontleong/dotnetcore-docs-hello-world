variable "location" {
  type        = string
  description = "Azure region to deploy resources"
}

variable "source_sea_resource_group_name" {
  type        = string
  description = "Resource group"
}

variable "source_ea_resource_group_name" {
  type        = string
  description = "Resource group to deploy resources"
}

variable "target_ea_resource_group_name" {
  type        = string
  description = "Resource group to deploy resources"
}

variable "vnet_terraform_principal_ea_001_name" {
  type        = string
  description = "vnet name"
}

variable "subnet_summer_ea_prod_app_new_name" {
  type        = string
  description = "Subnet ID for VMSS NIC"
}

variable "subnet_summer_ea_prod_web_new_name" {
  type        = string
  description = "Subnet ID for VMSS NIC"
}

variable "subnet_summer_ea_mgmt_new_name" {
  type        = string
  description = "Subnet ID for VMSS NIC"
}



variable "recoveyservicevault_rsv_terraform_principal_sea_001" {
  type        = string
  description = "rsv name"
}


variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "admin_username" {
  type        = string
  description = "Admin username for VMSS"
  # default     = "azureuser2"
}

variable "zones" {
  type        = list(string)
  description = "List of availability zones to deploy VMSS instances"
  # default     = ["1", "2", "3"]
}

variable "lb_principal_test_name" {
  type        = string
  description = "lb name lb-principal-test"
}


variable "lb_principal-test_backend_pool_name" {
  type        = string
  description = "Backend pool name for principal-test "
}

variable "keyvault_store_public_key_name" {
  type        = string
  description = "key vault name store public key"
}

variable "keyvault_secret_store_public_key_name" {
  type        = string
  description = "key vault's secret name store public key"
}


variable "vmss_azure_compute_galleries_name" {
  type        = string
  description = "gallery_name"
}

variable "vmss_azure_compute_galleries_name_image_name" {
  type        = string
  description = "image name"
}

variable "vmss_ulsmrwebprod01_name" {
  type        = string
  description = "name"
}

variable "vmss_ulsmrappprod01_name" {
  type        = string
  description = "name"
}

variable "vmss_ulsmrappprod01_sku" {
  type        = string
  description = "name"
}

variable "vmss_ulsmrwebprod01_sku" {
  type        = string
  description = "name"
}

variable "storageaccountsea_strgprinpalsea001_name" {
  type        = string
  description = "name"
}

variable "storageaccountsea_stgprinciea_name" {
  type        = string
  description = "name"
}

variable "sqlserver_icqsqlserversea_name" {
  type        = string
  description = "name"
}

variable "sqlserver_sqlserverleong_ea_001_name" {
  type        = string
  description = "name"
}

variable "sqlserver_database_icqsqldb_name" {
  type        = string
  description = "name"
}

variable "sqlserver_icqsqlserversea_resource_group_name" {
  type        = string
  description = "name"
}




//storage account tfstate
variable "storage_account_store_tfstatefile_storage_account_name" {
  type        = string
  description = "name"
}

variable "storage_account_store_tfstatefile_container_name" {
  type        = string
  description = "name"
}

variable "storage_account_store_tfstatefile_tfstate_key" {
  type        = string
  description = "name"
}

variable "storage_account_store_tfstatefile_resource_group_name" {
  type        = string
  description = "name"
}