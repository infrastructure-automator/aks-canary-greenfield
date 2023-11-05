#!/bin/bash

###########################
## Load Global Variables ##
###########################

export SERVICE_PRINCIPAL_CREDENTIALS_FILE="credentials/service-principal-credentials.json"
export TERRAFORM_CONFIGURATION_FILE="terraform"

export AZURE_SUBSCRIPTION_ID=$(az account show --query 'id' -o tsv)
export AZURE_TENANT_ID=$(az account show --query 'tenantId' -o tsv)

export terraform_deploy_plan_file_name="deploy.tfplan"
export terraform_destroy_plan_file_name="destroy.tfplan"
