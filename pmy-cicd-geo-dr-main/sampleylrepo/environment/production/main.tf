data "azurerm_shared_image_version" "latest_image" {
  name                = "latest"
  image_name          = var.vmss_azure_compute_galleries_name_image_name
  gallery_name        = var.vmss_azure_compute_galleries_name
  //change
  resource_group_name = var.source_ea_resource_group_name
}

# Get the existing Key Vault
data "azurerm_key_vault" "example" {
  name                = var.keyvault_store_public_key_name           
  resource_group_name = var.source_ea_resource_group_name  
}

# Get the secret from the Key Vault
data "azurerm_key_vault_secret" "ssh_key" {
  name         = var.keyvault_secret_store_public_key_name                       
  key_vault_id = data.azurerm_key_vault.example.id
}

data "azurerm_lb" "lb_principal_test" {
  name                = var.lb_principal_test_name     # Your LB name
  resource_group_name = var.source_ea_resource_group_name           # RG where LB exists
}

data "azurerm_lb_backend_address_pool" "backendpool001" {
  name                = var.lb_principal-test_backend_pool_name                 # Backend pool name
  loadbalancer_id     = data.azurerm_lb.lb_principal_test.id      # Reference LB ID
}




data "azurerm_virtual_network" "vnet-terraform-principal-ea-001"{
  name = var.vnet_terraform_principal_ea_001_name
  resource_group_name = var.source_ea_resource_group_name
}

data "azurerm_subnet" "subnet-summer-ea-prod-app-new" {
  name                 = var.subnet_summer_ea_prod_app_new_name
  virtual_network_name = data.azurerm_virtual_network.vnet-terraform-principal-ea-001.name
  resource_group_name  = data.azurerm_virtual_network.vnet-terraform-principal-ea-001.resource_group_name
}

data "azurerm_subnet" "subnet-summer-ea-prod-web-new" {
  name                 = var.subnet_summer_ea_prod_web_new_name
  virtual_network_name = data.azurerm_virtual_network.vnet-terraform-principal-ea-001.name
  resource_group_name  = data.azurerm_virtual_network.vnet-terraform-principal-ea-001.resource_group_name
}

data "azurerm_subnet" "subnet-summer-ea-mgmt-new" {
  name                 = var.subnet_summer_ea_mgmt_new_name
  virtual_network_name = data.azurerm_virtual_network.vnet-terraform-principal-ea-001.name
  resource_group_name  = data.azurerm_virtual_network.vnet-terraform-principal-ea-001.resource_group_name
}

//storage account for restore vm
data "azurerm_storage_account" "stgprinciea" {
  name                = var.storageaccountsea_stgprinciea_name   
  resource_group_name = var.source_ea_resource_group_name
}



# module "vmss_app1" {
#   source                   = "../../modules/vmss"
#   name                     = var.vmss_ulsmrappprod01_name
#   location                 = var.location
#   resource_group_name      = var.target_ea_resource_group_name 
#   computer_name_prefix     = var.vmss_ulsmrappprod01_name
#   admin_username           = var.admin_username
#   sku                      = var.vmss_ulsmrappprod01_sku
#   instances                = 2
#   zones                    = var.zones
#   ssh_public_key           = data.azurerm_key_vault_secret.ssh_key.value
#   source_image_id          = data.azurerm_shared_image_version.latest_image.id
#   subnet_id                = data.azurerm_subnet.subnet-summer-ea-prod-app-new.id
#   backend_address_pool_ids = [data.azurerm_lb_backend_address_pool.backendpool001.id]
#   tags                     = var.tags
# }

# module "vmss_web1" {
#   source                   = "../../modules/vmss"
#   name                     = var.vmss_ulsmrwebprod01_name
#   location                 = var.location
#   resource_group_name      = var.target_ea_resource_group_name 
#   computer_name_prefix     = var.vmss_ulsmrwebprod01_name
#   admin_username           = var.admin_username
#   sku                      = var.vmss_ulsmrwebprod01_sku
#   instances                = 2
#   zones                    = var.zones
#   ssh_public_key           = data.azurerm_key_vault_secret.ssh_key.value
#   source_image_id          = data.azurerm_shared_image_version.latest_image.id
#   subnet_id                = data.azurerm_subnet.subnet-summer-ea-prod-web-new.id
#   backend_address_pool_ids = [data.azurerm_lb_backend_address_pool.backendpool001.id]
#   tags                     = var.tags
# }


# module "autoscale_vmss_app1" {
#   source              = "../../modules/autoscale"
#   name                =  "as-${var.vmss_ulsmrappprod01_name}"
#   location            = var.location
#   resource_group_name = var.target_ea_resource_group_name
#   target_resource_id  = module.vmss_app1.id
#   tags                = var.tags
# }

# module "autoscale_vmss_web1" {
#   source              = "../../modules/autoscale"
#   name                = "as-${var.vmss_ulsmrwebprod01_name}"
#   location            = var.location
#   resource_group_name = var.target_ea_resource_group_name
#   target_resource_id  = module.vmss_web1.id
#   tags                = var.tags
# }
