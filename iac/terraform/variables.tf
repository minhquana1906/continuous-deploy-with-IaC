// Variables to use accross the project
// which can be accessed by var.project_id
variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = "test-431718"
}

variable "region" {
  description = "The region the cluster in"
  default     = "asia-southeast1"
}

variable "bucket" {
  description = "GCS bucket for MLE course"
  default     = "terraform-bucket-431718"
}
