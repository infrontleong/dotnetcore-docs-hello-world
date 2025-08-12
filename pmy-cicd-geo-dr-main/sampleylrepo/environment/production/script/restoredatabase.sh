#!/bin/bash
set -x 

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



SOURCE_SQL_SEA_sqlserver_source_sea_name=$(terraform output -raw script_variable_sqlserver_icqsqlserversea_name)
SOURCE_SQL_EA_sqlserverea_name=$(terraform output -raw script_variable_sqlserver_sqlserverleong_ea_001_name)
# //ea database name
SOURCE_SQL_SEA_sqlserver_source_database_sea_name=$(terraform output -raw script_variable_sqlserver_database_icqsqldb_name)
SOURCE_SQL_SEA_sqlserver_source_sea_resource_group_name=$(terraform output -raw script_variable_sqlserver_icqsqlserversea_resource_group_name)
SOURCE_SEA_RG=$(terraform output -raw script_variable_source_sea_resource_group_name)
SOURCE_EA_RG=$(terraform output -raw script_variable_source_ea_resource_group_name)

echo "test0, $SOURCE_SQL_SEA_sqlserver_source_sea_name"
echo "test1, $SOURCE_SQL_EA_sqlserverea_name"
echo "test2, $SOURCE_SQL_SEA_sqlserver_source_database_sea_name"
echo "test3, $SOURCE_SQL_SEA_sqlserver_source_sea_resource_group_name"
echo "test4, $SOURCE_SEA_RG"
echo "test5, $SOURCE_EA_RG"




echo "Getting list of recoverable databases"
#Trigger get list of recoverable databases.
# az sql db geo-backup list -s sqlserverleong -g rg-terraform-principal-sea-001 \

GEO_BACKUP_ID=$(az sql db geo-backup list \
  -s "$SOURCE_SQL_SEA_sqlserver_source_sea_name" \
  -g "$SOURCE_SQL_SEA_sqlserver_source_sea_resource_group_name" \
  --query "[?name=='$SOURCE_SQL_SEA_sqlserver_source_database_sea_name'].id" \
  -o tsv)

echo "Geo-backup ID: $GEO_BACKUP_ID"

if [[ -z "$GEO_BACKUP_ID" ]]; then
  echo " No geo-backup found for database icqsqldb. Exiting."
  exit 1
fi

echo "Initiating geo-restore for database"
#Trigger restore sql database
az sql db geo-backup restore \
  --dest-database "$SOURCE_SQL_SEA_sqlserver_source_database_sea_name" \
  --dest-server "$SOURCE_SQL_EA_sqlserverea_name" \
  --resource-group "$SOURCE_EA_RG" \
  --geo-backup-id "$GEO_BACKUP_ID" \
  --backup-storage-redundancy Geo
