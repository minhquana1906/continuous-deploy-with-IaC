# Ref: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/blob/master/examples/simple_autopilot_public
# To define that we will use GCP
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.80.0" // Provider version
    }
  }
  required_version = "1.9.4" // Terraform version
}

// The library with methods for creating and
// managing the infrastructure in GCP, this will
// apply to all the resources in the project
provider "google" {
  project     = var.project_id
  region      = var.region
}

// Google Cloud Storage
// https://cloud.google.com/storage/docs/terraform-create-bucket-upload-object
// or refer to https://registry.terraform.io/providers/hashicorp/google/latest/docs
# resource "google_storage_bucket" "static" {
#   name          = var.bucket
#   location      = var.region

#   # Enable bucket level access
#   uniform_bucket_level_access = true
# }

resource "google_storage_bucket" "static" {
  name          = var.bucket
  location      = var.region
  # force_destroy = true

  uniform_bucket_level_access = true
}

# // Google Compute Engine
# resource "google_compute_instance" "vm_instance" {
#   name         = "terraform-instance"
#   machine_type = "e2-micro"
#   zone         = "us-central1-c"

#   // This instances use ubuntu image
#   boot_disk {
#     initialize_params {
#       image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230727"
#     }
#   }

#   // Default network for the instance
#   network_interface {
#     network = "default"
#     access_config {}
#   }
# }

// Google Kubernetes Engine
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  // Enabling Autopilot for this cluster
  enable_autopilot = true
}




# Gets existing objects inside an existing bucket in Google Cloud Storage service (GCS)
# data "google_storage_bucket_objects" "files" {
#   bucket = "file-store"
# }

resource "google_compute_instance" "default" {
  name         = "demo-jenkins"
  machine_type = "e2-medium"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}


resource "google_compute_firewall" "default" {
  name    = "${var.project_id}-firewall"
  network = google_compute_network.default.name

  # allow {
  #   protocol = "icmp"
  # }

  allow {
    protocol = "tcp"
    ports    = ["8081", "50000"]
  }

  source_ranges = ["0.0.0.0/0"]

  # source_tags = ["web"]

  direction = "INGRESS"
}
