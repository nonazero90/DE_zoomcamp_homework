variable "project_id" {
  description = "GCP project that owns the homework resources."
  type        = string
}

variable "bucket_name" {
  description = "Globally unique name for the homework GCS bucket."
  type        = string
}

variable "dataset_id" {
  description = "BigQuery dataset name."
  type        = string
  default     = "de_zoomcamp_dataset"
}

variable "location" {
  description = "GCS and BigQuery multi-region."
  type        = string
  default     = "US"
}

variable "region" {
  description = "Default region for the Google provider."
  type        = string
  default     = "us-central1"
}
