## Purpose

This module essentially bootstraps an existing Google Cloud organization, setting up all the necessary Google Cloud resources and permissions to start utilizing a CFT. However, I've opted for a modification of the original version because it requires extensive permissions and access at the organizational level, which isn't always possible in some companies. The bootstrap step will use the current project for hosting two primary elements:
- Terraform State Bucket: This is where the Terraform state files are stored. These files are essential as they map resources to the configuration, keep track of metadata, and improve performance for large infrastructures.
- Custom Service Account: used by Terraform to create new resources in Google Cloud.

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