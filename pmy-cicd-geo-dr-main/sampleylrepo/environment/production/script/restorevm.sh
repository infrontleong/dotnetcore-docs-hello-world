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



SOURCE_SEA_RG=$(terraform output -raw script_variable_source_sea_resource_group_name)
SOURCE_EA_RG=$(terraform output -raw script_variable_source_ea_resource_group_name)
TARGET_EA_RG=$(terraform output -raw script_variable_target_ea_resource_group_name)
SOURCE_SEA_RSV=$(terraform output -raw script_variable_recoveyservicevault_source_rsv_terraform_principal_sea_001)
STORAGE_ACCOUNT_stgprinciea_ID=$(terraform output -raw script_variable_storage_account_stgprinciea_id)
TARGET_EA_vnet_subnet_summer_ea_mgmt_new_ID=$(terraform output -raw script_variable_subnet_summer_ea_mgmt_new_name)
TARGET_EA_vnet_name=$(terraform output -raw script_variable_vnet_terraform_principal_ea_001_name)

echo "test0, $SOURCE_SEA_RG"
echo "test1, $SOURCE_EA_RG"
echo "test2, $TARGET_EA_RG"
echo "test3, $SOURCE_SEA_RSV"
echo "test4, $STORAGE_ACCOUNT_stgprinciea_ID"
echo "test5, $TARGET_EA_vnet_subnet_summer_ea_mgmt_new_ID"
echo "test6, $TARGET_EA_vnet_name"

# Define list of VMs (container name = item name = VM name)
vm_names=(
  "vm-terraform-principal-app-001"  # 1st VM
  "vm-terraform-principal-app-002"  # 2nd VM
)

# Loop through each VM
for vm in "${vm_names[@]}"; do
  echo " Starting restore for VM: $vm"

  # Get latest recovery point
  recoveryPointId=$(az backup recoverypoint list \
    --resource-group "$SOURCE_SEA_RG" \
    --vault-name "$SOURCE_SEA_RSV" \
    --backup-management-type AzureIaasVM \
    --container-name "$vm" \
    --item-name "$vm" \
    --query "[?tierType=='SnapshotAndVaultStandard'|| tierType=='VaultStandard'] | [0].name" \
    --output tsv)

  if [[ -z "$recoveryPointId" ]]; then
    echo " No recovery point found for $vm. Skipping."
    continue
  fi

  echo " Recovery point for $vm: $recoveryPointId"

  # Restore VM
  az backup restore restore-disks \
    --resource-group "$SOURCE_SEA_RG" \
    --vault-name "$SOURCE_SEA_RSV" \
    --container-name "$vm" \
    --item-name "$vm" \
    --restore-mode AlternateLocation \
    --storage-account "$STORAGE_ACCOUNT_stgprinciea_ID" \
    --use-secondary-region \
    --target-resource-group "$TARGET_EA_RG" \
    --rp-name "$recoveryPointId" \
    --target-vm-name "restore-$vm" \
    --target-vnet-name "$TARGET_EA_vnet_name" \
    --target-vnet-resource-group "$SOURCE_EA_RG" \
    --target-subnet-name "$TARGET_EA_vnet_subnet_summer_ea_mgmt_new_ID"

  echo " Restore triggered for VM: $vm as restore-$vm"
  echo "--------------------------------------------------"
done



