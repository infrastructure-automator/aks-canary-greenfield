#!/bin/bash

############################
## Destroy Infrastructure ##
############################

{
    echo; echo ${FORMAT_HIGHLIGHT_1}"Terraform Initialize"${FORMAT_NORMAL}
    terraform -chdir=${TERRAFORM_CONFIGURATION_FILE} init

} && {
    echo; echo ${FORMAT_HIGHLIGHT_1}"Terraform Destroy Plan"${FORMAT_NORMAL}
    terraform -chdir=${TERRAFORM_CONFIGURATION_FILE} plan -destroy \
        -out ${terraform_deploy_plan_file_name} \
        -var-file="variables.tfvars" \
        -var-file=../application-settings.tfvars

} && {
    echo; echo ${FORMAT_HIGHLIGHT_1}"Terraform Apply"${FORMAT_NORMAL}
    terraform -chdir=${TERRAFORM_CONFIGURATION_FILE} apply ${terraform_deploy_plan_file_name}

} && {
    echo; echo ${FORMAT_HIGHLIGHT_1}"Remove Terraform Plan File"${FORMAT_NORMAL}
    rm ${TERRAFORM_CONFIGURATION_FILE}/${terraform_deploy_plan_file_name}

}
