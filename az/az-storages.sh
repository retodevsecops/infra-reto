#!/bin/bash
az group exists -n rg_reto_devsecops
STACCOUNT=$(az storage account check-name --name $STORAGEACCOUNTNAME)
VALUE=$(jq -r '.nameAvailable' <<< $STACCOUNT)

if [[ "$VALUE" == "true" ]]; then
    az storage account create \
    --name $STORAGEACCOUNTNAME \
    --resource-group $RESOURCEGROUP \
    --location $LOCATION \
    --sku Standard_RAGRS \
    --kind StorageV2   

    JSON=$(az storage account keys list \
    --resource-group $RESOURCEGROUP \
    --account-name $STORAGEACCOUNTNAME)

    KEYST=( $(jq -r '.[0].value' <<< $JSON) ) 
                                
    az storage container create -n $STORAGECONTAINERNAMEACR --account-name $STORAGEACCOUNTNAME --account-key $KEYST        
    az storage container create -n $STORAGECONTAINERNAMEAKS --account-name $STORAGEACCOUNTNAME --account-key $KEYST
else

    JSON=$(az storage account keys list \
    --resource-group $RESOURCEGROUP \
    --account-name $STORAGEACCOUNTNAME)

    KEYST=( $(jq -r '.[0].value' <<< $JSON) ) 
                                
    az storage container create -n $STORAGECONTAINERNAMEACR --account-name $STORAGEACCOUNTNAME --account-key $KEYST        
    az storage container create -n $STORAGECONTAINERNAMEAKS --account-name $STORAGEACCOUNTNAME --account-key $KEYST
fi