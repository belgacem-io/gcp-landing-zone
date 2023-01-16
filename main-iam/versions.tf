terraform {
  required_version = ">= 0.13"
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = ">= 2.0.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.77"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.77"
    }
  }

}