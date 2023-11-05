#!/bin/bash

##################################
## Initialize Service Principal ##
##################################

## Check for Service Principal File
if [ ! -f ${SERVICE_PRINCIPAL_CREDENTIALS_FILE} ] || [ ! -s ${SERVICE_PRINCIPAL_CREDENTIALS_FILE} ]
then
    echo; echo ${FORMAT_ERROR}"Service Principal Credentials Not Found"
    source scripts/create-service-principal.sh
fi

## Load Service Principal
export TF_VAR_AZURE_TENANT_ID=$(jq -r ".azure_tenant_id" ${SERVICE_PRINCIPAL_CREDENTIALS_FILE})
export TF_VAR_AZURE_SUBSCRIPTION_ID=$(jq -r ".azure_subscription_id" ${SERVICE_PRINCIPAL_CREDENTIALS_FILE})
export TF_VAR_SERVICE_PRINCIPAL_APPLICATION_ID=$(jq -r ".sp_application_id" ${SERVICE_PRINCIPAL_CREDENTIALS_FILE})
export TF_VAR_SERVICE_PRINCIPAL_SECRET=$(jq -r ".sp_password" ${SERVICE_PRINCIPAL_CREDENTIALS_FILE})
