# Outputs the URL of the service
output "demo_service_url" {
  value = "${google_cloud_run_service.demo_service.status[0].url}"
}
