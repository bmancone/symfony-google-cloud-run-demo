variable "project_id" {
  type        = string
  default     = "symfony-cloud-run-demo"
  description = "The id of the GCP project."
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "The location of the cloud run instance."
}

variable "service_name" {
  type        = string
  default     = "demo-app"
  description = "The name of the service to deploy."
}

# This variable will be passed on the CLI.
# See : https://www.terraform.io/docs/configuration/variables.html#variables-on-the-command-line
variable "image_name" {
  type        = string
  description = "The name of the image to deploy."
}
