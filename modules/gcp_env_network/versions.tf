terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0, < 5.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}