#!/bin/bash
# Move into the Terraform working directory (important!)

# cd /home/icgadmin/azagent/_work/1/s/sampleylrepo/environment/production/
cd "$SYSTEM_DEFAULTWORKINGDIRECTORY/sampleylrepo/environment/production" || exit 1
echo "Current working directory: $(pwd)"


# Initialize so terraform knows the backend location
# Read values from terraform.tfvars
STORAGE_ACCOUNT_NAME=$(grep '^storage_account_store_tfstatefile_storage_account_name' terraform.tfvars | cut -d '"' -f2)
CONTAINER_NAME=$(grep '^storage_account_store_tfstatefile_container_name' terraform.tfvars | cut -d '"' -f2)
TFSTATE_KEY=$(grep '^storage_account_store_tfstatefile_tfstate_key' terraform.tfvars | cut -d '"' -f2)
RG_NAME=$(grep '^storage_account_store_tfstatefile_resource_group_name' terraform.tfvars | cut -d '"' -f2)

echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
echo "Container Name: $CONTAINER_NAME"
echo "TF State Key: $TFSTATE_KEY"
echo "Resource Group Name: $RG_NAME"


# Run terraform init dynamically
terraform init -input=false \
  -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
  -backend-config="container_name=$CONTAINER_NAME" \
  -backend-config="key=$TFSTATE_KEY" \
  -backend-config="resource_group_name=$RG_NAME"


SOURCE_SEA_StorageAccount_name_strgprinpalsea001=$(terraform output -raw script_variable_storageaccountsea_strgprinpalsea001_name)
SOURCE_SEA_RG=$(terraform output -raw script_variable_source_sea_resource_group_name)

echo "test1 $SOURCE_SEA_StorageAccount_name_strgprinpalsea001"
echo "test2 $SOURCE_SEA_RG"

# Trigger unplanned failover
az storage account failover \
  --resource-group $SOURCE_SEA_RG \
  --name $SOURCE_SEA_StorageAccount_name_strgprinpalsea001 \
  --failover-type unplanned \
  --yes

echo "Failover Storage Account Completed"
echo "Start update Redunduncy to GRS"

# Update to GRS
az storage account update \
  --name $SOURCE_SEA_StorageAccount_name_strgprinpalsea001 \
  --resource-group $SOURCE_SEA_RG \
  --sku Standard_GRS
