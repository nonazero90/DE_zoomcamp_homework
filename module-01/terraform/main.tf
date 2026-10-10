terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.51"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "data_lake" {
  name                        = var.bucket_name
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.dataset_id
  project    = var.project_id
  location   = var.location
}
