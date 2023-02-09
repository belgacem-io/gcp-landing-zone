## Purpose
The purpose of this step is to bootstrap a Google cloud landing zone, creating all the required resources and permissions.

## Prerequisites
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
8. On bootstrap project, enable the flowing APIs
   - IAM Service Account Credentials API
   - Cloud Resource Manager API