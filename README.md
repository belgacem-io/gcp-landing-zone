### Requirements
1. GCP account with organisation setup
2. Billing account ID
3. You can used an organization or a folder as parent container

### Installation
1. Create a dedicated folder
2. Create a bootstrap GCP project that will be used for running terraform scripts
3. Create a service account with the following permissions
   - organisation -> Billing Account Costs Manager
   - organisation -> Billing Account User
   - folder -> Owner
   - folder -> Project Creator
   - folder -> Security Admin
   - project -> Service Account Token Creator
   - project -> Service Account User
4. Create the following groups
   - xx-organization-admins@example.com
   - xx-security-admins@example.com
   - xx-security-reviewers@example.com
   - xx-billing-admins@example.com
   - xx-organization-viewers@example.com
   - xx-network-admins@example.com
   - xx-network-viewers@example.com
4. Clone the repo
   ```sh
   git clone https://github.com/h-belgacem/eks-apigee.git
   ```
5. Setup your local environment
   ```sh
   make up
   ```
6. Create a service account key and download the credentials file as JSON
7. Create an '.auth/env' file and add GCP credentials 
   ```sh
    export GOOGLE_APPLICATION_CREDENTIALS=/wks/.auth/application_default_credentials.json
    export PROJECT_ID=xx-bootstrap-prod-375008
    export PROJECT_NAME=xx-bootstrap-prod
   ```
8. Init bootstrap project 
   ```sh
    make init bootstap && make apply bootstap
   ```
9. Create and configure infra projects
   ```sh
    make init infra && make apply infra
   ```
10. Create and configure env projects
   ```sh
    make init env && make apply env
   ```
11. Create and configure business projects
   ```sh
    make init bp && make apply bp
   ```