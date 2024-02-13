resource "google_service_account" "default" {
 account_id   = var.account_id
 display_name = var.display_name
 project = var.projectid
}



locals{
 container-cluster =[for f in fileset("${path.module}/configs/", "[^_]*.yaml") : yamldecode(file("${path.module}/configs/${f}"))]
 container-cluster-flatten = flatten([
    for info in local.container-cluster : [
      for cc in try(info.containerclusterlist, []) :{
        name = cc.name
      }
    ]
])
}


resource "google_container_cluster" "primary" {
  for_each            ={for kcc in local.container-cluster-flatten: "${kcc.name}"=>kcc }
  name                = each.value.name
  location = "us-central1"
  

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  project = var.projectid
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.service_account
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
