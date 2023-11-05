#!/bin/bash

##############################
## Create Service Principal ##
##############################

## Get Service Principal Name
echo
read -p ${FORMAT_NORMAL}"Please Provide a Name for the Service Principal: "${FORMAT_HIGHLIGHT_1} SERVICE_PRINCIPAL_NAME
echo -e ${FORMAT_NORMAL}"The Selected Service Principal Name is \"${FORMAT_HIGHLIGHT_1}${SERVICE_PRINCIPAL_NAME}${FORMAT_NORMAL}\""

## Create Service Principal
SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac \
    --name "$SERVICE_PRINCIPAL_NAME" \
    --role Contributor \
    --scopes "subscriptions/$AZURE_SUBSCRIPTION_ID" \
    --output json --only-show-errors)

# Set App ID and Password
SERVICE_PRINCIPAL_APPLICATION_ID=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_PASSWORD=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

# Save Service Principal Credentials
jq --null-input \
    --arg _azure_tenant_id "${AZURE_TENANT_ID}" \
    --arg _azure_subscription_id "${AZURE_SUBSCRIPTION_ID}" \
    --arg _sp_application_id "${SERVICE_PRINCIPAL_APPLICATION_ID}" \
    --arg _sp_password "${SERVICE_PRINCIPAL_PASSWORD}" \
    --arg _sp_display_name "${SERVICE_PRINCIPAL_NAME}" \
    '{
        "azure_tenant_id": $_azure_tenant_id,
        "azure_subscription_id": $_azure_subscription_id,
        "sp_display_name": $_sp_display_name,
        "sp_application_id": $_sp_application_id,
        "sp_password": $_sp_password
    }' > ${SERVICE_PRINCIPAL_CREDENTIALS_FILE}
