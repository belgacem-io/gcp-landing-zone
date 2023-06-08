### Organization Design
This landing zone is maint to be used for small/medium companies, this is why i decided to go with a simple organizational structure and associate each project with many functions. Here the structure:
   ```text
      example-organization(<org_domain>)
      |
      ├── <org_prefix>-bootstrap-prod (1)
      |
      └── <org_prefix>-infra (2)
      ├── <org_prefix>-logging-prod  (3)
      ├── <org_prefix>-security-prod (4)
      └── <org_prefix>-nethub-prod   (5)
      
      └── dev-Environment (6)
      └── <org_prefix>-netenv-dev   (7)
      └── <org_prefix>-business-dev (8)
      ├── <org_prefix>-prj1-dev   (9)
      ├── <org_prefix>-prj2-dev   (9)
      └── <org_prefix>-prj3-dev   (9)
      
      └── ...
      
      └── prod-Environment (6)
      └── <org_prefix>-netenv-prod   (7)
      └── <org_prefix>-business-prod (8)
      ├── <org_prefix>-prj1-prod   (9)
      ├── <org_prefix>-prj2-prod   (9)
└── <org_prefix>-prj3-prod   (9)
   ```
- **Bootstrap project (1)** : This project serves as IAC main repository as it used for hosting terraform service account and the bucket for storing its state.
- **Infrastructure folder (2)**: Infrastructure, often referred to as the “common” or “platform” , folder this is the compartment where projects with shared resources reside. It plays a crucial role in hosting various projects that encapsulate organization-level elements like the Network Hub, secrets, logging, and more. It is designed to store the following projects: Logging, Nethub and Security
- **Logging project (3)**: This project is organization wide billing, applications and infra logs. The logs are collected into BigQuery datasets which you can then use for general querying, dashboarding, and reporting. Logs are also exported to Pub/Sub, a Cloud Storage bucket, and a log bucket.
- **Nethub project (4)**: This project is designed to serve as the hub for both the networks and DNS within the organization. It essentially contains two types of networks : DMZ and Internal Hub.
- **Security project (5)**: This project, overseen by your organization’s security teams, forms the foundation for centralized audit logs and security alerts at the organization level. This secure hub will feature a Pub/Sub topic and subscription, along with a Security Command Center notification set up to broadcast all new findings to the established topic. Furthermore, it serves as a home for the Secret Manager, where your organization can safely store and share secrets.
- **Environments folders (6)**: For the sake of enhanced security and streamlined management, our architecture includes a distinct folder for each environment, with the capacity to extend this division into individual security zones as well. Within each environment-specific folder, we create a series of projects intended to provide shared services across the various projects housed in the same folder. This organized approach is designed to facilitate effective cooperation and secure operation within each individual environment.
- **NetEnv project (7)**: unlike the NetHub, this project is specifically designed to accommodate resources related to a single environment or security zone. It is charged with the task of ensuring secure communication among all projects within the same environment. Additionally, it provides common services, such as a Bastion Host, further enhancing its utility within the designated environment.
- **Business projects (9)**: Here we create the service projects with a standard configuration that are attached to the Shared VPC created in the previous steps. Each project can be associated to an application or team.

### Terraform modules structure
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
<td><a href="./main-hybrid/README.md">Step 4 - hybrid</a></td>
<td>Set up hybrid connectivity to your existing sites.</td>
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