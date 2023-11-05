#!/bin/bash

#########################
## Get AKS Credentials ##
#########################

{
    az login --service-principal \
        --username ${TF_VAR_SERVICE_PRINCIPAL_APPLICATION_ID} \
        --password ${TF_VAR_SERVICE_PRINCIPAL_SECRET} \
        --tenant ${TF_VAR_AZURE_TENANT_ID} \
        --only-show-errors --output none

} && {
    export TF_VAR_aks_cluster_name=$(terraform -chdir=${TERRAFORM_CONFIGURATION_FILE} output -raw aks_cluster_name)

} && {
    export TF_VAR_aks_resource_group_name=$(terraform -chdir=${TERRAFORM_CONFIGURATION_FILE} output -raw aks_resource_group_name)

} && {
    az aks get-credentials --admin \
        --name ${TF_VAR_aks_cluster_name} \
        --resource-group ${TF_VAR_aks_resource_group_name} \
        --subscription ${TF_VAR_AZURE_SUBSCRIPTION_ID} \
        --only-show-errors --output none

}