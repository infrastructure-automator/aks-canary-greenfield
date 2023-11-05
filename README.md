# AKS Cluster Deployment with Advanced Routing

This repository demonstrates creating an Azure Kubernetes Service (AKS) Cluster with an NGINX Ingress configured for Blue/Green/Canary-Weighted Routing in a completely greenfield Azure Environment with Terraform.

## Prerequisites

Before running the deployment script, ensure you have the following tools installed on your machine:

- **Azure CLI**
- **jq** (JSON query)
- **Terraform**
- **Kubectl**
- **Helm**

## Steps

1. **Setup:** From the root of the repository, Run: 
    ```bash
    source run.sh
    ```

1. **Terraform Deploy:** Run
    ```bash
    source scripts/deploy-infrastructure
    ```

1. **Terraform Destroy:** Run
    ```bash
    source scripts/destroy-infrastructure.sh
    ```

## Features
1. Running the setup command of `source run.sh` will:
    - Configure colored bash output.
    - Verify that all prerequisite software is installed.
    - Add the NGINX Helm repo.
    - Update the NGINX Helm repo.
    - Verify a valid current az login or prompt the user to login.
    - Configure a Service Principal with Contribute access on the current Azure Subscription.
    - Display commands to Deploy and Destroy Infrastructure.

1. Running the deploy command `source scripts/deploy-infrastructure.sh` will:
    - Perform **terraform init**.
    - Perform **terraform plan**.
    - Perform **terraform apply**.
    - Retrieve AKS Credentials from the new AKS Cluster.

1. Running the destroy command `source scripts/destroy-infrastructure.sh` will:
    - Perform **terraform init**.
    - Perform **terraform plan -destroy**.
    - Perform **terraform apply**.

1. The Routing Features allow for:
    - Zero-downtime cutovers to new deployment images.
    - Zero-downtime failback to old deployment images.
    - Testing deployments of specific URLs for each stage of each application, regardless of the configuration of the main application ingress.
    - Canary weight control of primary application traffic.
    - A/B Testing of primary application traffic.

## Components of the Terraform Configuration:
- Resource Group
- Virtual Network and Subnets
- Azure Kubernetes Cluster
- NGINX Ingress Deployment via Helm Chart
- NGINX Health Probe Target
- Kubernetes Deployment for every stage of every application defined in `application-settings.tfvars`
- Kubernetes Service for each deployment
- NGINX Ingress for every Kubernetes Service
- NGINX Primary (blue) and Canary (green) Ingress
- Outputs of the publicly available URLs for every application and stage


## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/infrastructure-automator/aks-canary-greenfield.git
   cd aks-canary-greenfield
1. Follow the steps outlined in the **"Steps"** section above.


## Configuration
- The deployed applications are configured with the `application-settings.tfvars` file.  
    - Note: This file defines a single Terraform variable `application-settings`
    - This variable is a map of objects that contain the following elements:
        - `blue_stage`: "Which of the three stages houses primary traffic?" (`one`, `two`, or `three`)
        - `green_stage`: "Which of the three stages houses canary traffic?" (`one`, `two`, or `three`)
        - `green_weight`: "What percentage of production traffic will go to the Canary Deployment? (An Integer from `0` and `100`)
        - `stage_images`: "The Containerized Image to deploy to the specific stage"

    Example configuration:

    ```hcl
    ## application-settings.tfvars

    application_settings = {
        "alpha-app" = {
            blue_stage        = "one"
            green_stage       = "two"
            green_weight      = 0
            stage_one_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
            stage_two_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
            stage_three_image = ""
        }
        "beta-app" = {
            blue_stage        = "one"
            green_stage       = "two"
            green_weight      = 50
            stage_one_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
            stage_two_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
            stage_three_image = ""
        }
    }
    ```

- Other Configurations such as `azure_region`, `aks pod cpu and memory` can be configured by editing the `./terraform/variables.tfvars` file. 


## License
This project is licensed under the MIT License - see the `LICENSE` file for details.

## Screenshots
**Setup Script**

![Setup Script](https://github.com/infrastructure-automator/aks-canary-greenfield/blob/main/screenshots/setup-script.png?raw=true)

**Deploy Script**

![Deploy Script](https://github.com/infrastructure-automator/aks-canary-greenfield/blob/main/screenshots/deploy-script.png?raw=true)

**Frontend and Backend URLs via Terraform Outputs**

![Terraform Output Containing App and Stage URLs](https://github.com/infrastructure-automator/aks-canary-greenfield/blob/main/screenshots/outputs.png?raw=true)

**Example of FrontEnd routing to Target Backend.**  
In this example, 100% of Primary Traffic goes to Stage One

![Browser View](https://github.com/infrastructure-automator/aks-canary-greenfield/blob/main/screenshots/alpha-app-frontend-backend.png?raw=true)