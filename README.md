### Requirements
1. GCP account with organisation setup
2. Billing account ID
3. You can used an organization or a folder as parent container

### Setup Google cloud requirements
1. Create a dedicated folder
2. Create a bootstrap GCP project that will be used for running terraform scripts
3. Create a service account with the following permissions
   - organisation -> Billing Account Costs Manager
   - organisation -> Billing Account User
   - folder -> Owner
   - folder -> Project Creator
   - folder -> Security Admin
   - folder -> Service Account Token Creator
   - folder -> Service Account User
4. Create the following groups (optional)
   - xx-organization-admins@example.com
   - xx-security-admins@example.com
   - xx-security-reviewers@example.com
   - xx-billing-admins@example.com
   - xx-organization-viewers@example.com
   - xx-network-admins@example.com
   - xx-network-viewers@example.com
5. On bootstrap project, enable the flowing APIs
   - IAM Service Account Credentials API
   - Cloud Resource Manager API

### Installation
1. Clone the repo
   ```sh
   git clone https://github.com/h-belgacem/eks-apigee.git
   ```
2. For each module main-xxx, create a terraform.tfvars file with the appropriates values
3. Create a service account key and download the credentials file as JSON
4. Create an '.auth/env' file and add required variables 
   ```sh
   ##################################### GCP Credentials ###################
   export GOOGLE_APPLICATION_CREDENTIALS=/wks/.auth/application_default_credentials.json
   export PROJECT_ID=xx-bootstrap-prod-375008
   export PROJECT_NAME=xx-bootstrap-prod
   
   ##################################### tfvars generator ###################
   export REGION=europe-west9
   export ORGANISATION_ID=25135412153
   export ORGANISATION_DOMAIN=example.com
   export ORGANISATION_PREFIX=xx
   export CONTAINER_ID=folders/2565982345
   export BILLING_ACCOUNT_ID=AAAAA-BBBBB-CCCCC
   export AUTOMATION_SA=lz-automation@xx-bootstrap-prod-375008.iam.gserviceaccount.com
   #export TF_LOG=INFO
   ```
5. Setup your local environment
   ```sh
    make up
    ./terraformd --insall
   ```
   terraform
6. Init bootstrap project 
   ```sh
    terraformd -chdir=main-bootstap init && terraformd -chdir=main-bootstap apply
   ```
7. Create and configure infra projects
   ```sh
    terraformd -chdir=main-infra init
    terraformd -chdir=main-infra apply -target module.infra_projects
    terraformd -chdir=main-infra apply
   ```
8. Create and configure env projects
   ```sh
    terraformd -chdir=main-env init && terraformd -chdir=main-env apply
   ```
9. Create and configure business projects
   ```sh
    terraformd -chdir=main-bp init && terraformd -chdir=main-bp apply
   ```