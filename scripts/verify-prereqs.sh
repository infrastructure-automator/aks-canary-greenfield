#!/bin/bash

####################
## Verify Prereqs ##
####################

## Check commands to test
declare -a programs_to_check=(
    "jq"
    "terraform"
    "az"
    "kubectl"
    "helm"
)

function command_exists () {
    command -v "${1}" >/dev/null 2>&1
}

for target_program in ${programs_to_check[@]}; do
    if ! command_exists ${target_program}; then
        echo; echo "${target_program} is not installed.  Please install ${target_program} and re-run script"
    fi
done

{
    echo; echo ${FORMAT_HIGHLIGHT_1}"Add NGINX Helm Repo"${FORMAT_NORMAL}
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

} && {
    echo; echo ${FORMAT_HIGHLIGHT_1}"Update HELM Repo"${FORMAT_NORMAL}
    helm repo update

}