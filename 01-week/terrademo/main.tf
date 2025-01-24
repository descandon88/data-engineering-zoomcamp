terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "5.6.0"
        }
    }
}

provider "google" {
    project     = "helical-casing-353401"
    region      = "us-central1"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "helical-casing-353401-terra-bucket"
  location      = "US"
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