<table>
<tbody>
<tr>
<td><a href="./main-bootstrap/README.md">Step 0 - bootstrap</a></td>
<td>Bootstraps a Google Cloud organization and creates all the required resources and permissions. 
</td>
</tr>
<tr>
<td><a href="./main-infra/README.md">Step 1 - infrastructure</a></td>
<td>Sets up top-level shared folders, monitoring and networking projects, and organization-level logging, and sets baseline security settings through organizational policy.</td>
</tr>
<tr>
<td><a href="./main-env/README.md"><span style="white-space: nowrap;">Step 2 - environments</span></a></td>
<td>Sets up development, non-production, and production environments within the Google Cloud organization that you've created.</td>
</tr>
<tr>
<td><a href="./main-bp/README.md">Step 3 - projects</a></td>
<td>Set up a folder structure, projects for applications, which are connected as service projects to the shared VPC created in the previous stage.</td>
</tr>
<tr>
<td><a href="./main-custom/README.md">Step 4 - custom</a></td>
<td>Set up custom services for application.</td>
</tr>
</tbody>
</table>

### Prerequisites

Before stating, make sure that you've done the following:

1. Set up a Google Cloud [organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization).
2. Set up a Google Cloud [billing account](https://cloud.google.com/billing/docs/how-to/manage-billing-account).
3. Create Cloud Identity or Google Workspace groups for organization and billing admins.
4. Create a dedicated folder (optional, can use the organisation as container)
5. Create a bootstrap GCP project that will be used for running terraform scripts
6. Create a service account with the following permissions
    - organisation -> Billing Account Costs Manager
    - organisation -> Billing Account User
    - folder -> Owner
    - folder -> Project Creator
    - folder -> Security Admin
    - folder -> Service Account Token Creator
    - folder -> Service Account User
7. Create the following groups (optional)
    - xx-organization-admins@example.com
    - xx-security-admins@example.com
    - xx-security-reviewers@example.com
    - xx-billing-admins@example.com
    - xx-organization-viewers@example.com
    - xx-network-admins@example.com
    - xx-network-viewers@example.com
8. In bootstrap project, enable the flowing APIs
    - IAM Service Account Credentials API
    - Cloud Resource Manager API

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/belgacem-io/gcp-landing-zone.git
   ```
2. For each module main-xxx, create a terraform.tfvars file with the appropriates values
3. Create a service account key and download the credentials file as JSON
4. Create an '.auth/env' file and add required variables
   ```sh
   ##################################### GCP Credentials ###################
   export GOOGLE_APPLICATION_CREDENTIALS=/wks/.auth/application_default_credentials.json
   export PROJECT_ID=xx-myproject-prod-xxx
   export PROJECT_NAME=xx-myproject-prod
   ```
5. Setup your local environment
   ```sh
    source .auth/env
   ``` 
6. Configure [bootstrap project](./main-bootstrap/README.md)
   ```sh
    terraform -chdir=main-bootstrap init && terraform -chdir=main-bootstrap apply
   ```
7. for each main-xxx module, add a 'backend.tf' file with the following content
   ```hcl
    terraform {
       backend "gcs" {
       bucket  = "<generated bucket name >"
       prefix  = "terraform/main-xxx/state"
       }
   }
   ``` 
8. Create and configure [infrastructure projects](./main-infra/README.md)
   ```sh
    terraform -chdir=main-infra init
    terraform -chdir=main-infra apply
    terraform -chdir=main-infra apply
   ```
9. Create and configure [environments projects](./main-env/README.md)
   ```sh
    terraform -chdir=main-env init && terraform -chdir=main-env apply
   ```
10. Create and configure [business projects](./main-bp/README.md)
   ```sh
    terraform -chdir=main-bp init && terraform -chdir=main-bp apply
   ```

### Generate a test example
1. Add local env variables to '.auth/env' file
   ```sh 
   ##################################### tfvars generator ###################
   export REGION=europe-west9
   export ORGANISATION_ID=25135412153
   export ORGANISATION_PUBLIC_DOMAIN=example.com
   export ORGANIZATION_NAME=xx
   export CONTAINER_ID=folders/2565982345
   export BILLING_ACCOUNT_ID=AAAAA-BBBBB-CCCCC
   export IAC_SERVICE_ACCOUNT=lz-automation@xx-myproject-prod-xxx.iam.gserviceaccount.com
   export IAC_SERVICE_BACKEND_BUCKET=xx-prod-bkt-xxxxx-tfstate-xxxx
   #export TF_LOG=INFO
   ```
2. Deploy docker container
   ```sh 
   # Deploy docker container
   make up
   ```

3. Generate sample files
   ```sh
   make gen
   ```

### Generate terraform docs
1. Deploy docker container
   ```sh 
   # Deploy docker container
   make up
   ```

2. Generate terraform docs
   ```sh
   make docs
   ```