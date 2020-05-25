# Our Cloud Run service
# The documentation is available here : https://www.terraform.io/docs/providers/google/r/cloud_run_service.html
resource "google_cloud_run_service" "demo_service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  metadata {
    namespace = var.project_id
  }

  template {
    spec {
      containers {
        image = var.image_name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Public access for this Cloud Run service
# allUsers : anyone who is on the internet; with or without a Google account.
# The documentation available here : https://www.terraform.io/docs/providers/google/r/cloud_run_service_iam.html#member-members
data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# Public access for this Cloud Run service
# The documentation available here : https://www.terraform.io/docs/providers/google/r/cloud_run_service_iam.html#google_cloud_run_service_iam_policy
resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.demo_service.location
  project     = var.project_id
  service     = google_cloud_run_service.demo_service.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
