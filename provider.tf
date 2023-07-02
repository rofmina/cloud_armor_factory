provider "google" {
  project_id = var.project_id
  region  = var.region
}

provider "google-beta" {
  project_id = var.project_id
  region  = var.region
}
