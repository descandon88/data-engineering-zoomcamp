terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  #project = "helical-casing-353401"
  credentials = file(var.credentials)
  project     = var.project
  #region  = "us-central1"
  region = var.region
}

resource "google_storage_bucket" "demo-bucket" {
  #name          = "helical-casing-353401-terra-bucket"
  name = var.gcs_bucket_name
  #location      = "US"
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = "demo_dataset"
  location   = var.location
}