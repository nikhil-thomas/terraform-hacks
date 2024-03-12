terraform {
    required_providers {
      google = {
        source = "hashicorp/google"
        version = "~>4.0"
      }
    }
}

provider "google" {
  project = "sebastian-391809"
}

resource "google_storage_bucket" "website_bucket" {
  name = "nikthoma-website-bucket"
  location = "US"
  force_destroy = true # Destroys the bucket when we destroy our Terraform setup
  website {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }
}
#
#resource "google_storage_bucket_acl" "public_read" {
#  bucket = google_storage_bucket.website_bucket.name
#  predefined_acl = "publicRead"
#}

#resource "google_storage_bucket_acl" "public_read" {
#  bucket = google_storage_bucket.website_bucket.name
#
#}

resource "google_storage_bucket_iam_binding" "website_public_read" {
    bucket = google_storage_bucket.website_bucket.name
    role = "roles/storage.objectViewer"
    members = ["allUsers"]
}

resource "google_storage_bucket_object" "index_html" {
  name = "index.html"
  bucket = google_storage_bucket.website_bucket.name
  source = "index.html"
  content_type = "text/html"
}

resource "google_storage_bucket_object" "error_html" {
  name = "404.html"
  bucket = google_storage_bucket.website_bucket.name
  source = "404.html"
  content_type = "text/html"
}

output "website_endpoint" {
  value = google_storage_bucket.website_bucket.url
}

output "website_acl" {
  value = google_storage_bucket_iam_binding.website_public_read.role
}


