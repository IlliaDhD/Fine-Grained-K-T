# === Realm Configuration ===
variable "realm_name" {
  type        = string
  default     = "policies-test"
  description = "The name for Keycloak realm"
}

# === Provider's Configuration ===
variable "provider_client_id" {
  type = string
  default = "terraform-provider"  # pass your value here
  description = "Terraform Provider's client id"
}

variable "provider_client_secret" {
  type = string
  default = "QpHcp8eEKB5ohacoXfDKAC3ZiXkoMpkm" # pass your value here
  description = "Terraform Provider's client secret"
}

variable "keycloak_url" {
  type = string
  default = "http://127.0.0.1:8081"
  description = "Keycloak's deployment URL"
}

# === App's Client Configuration ===
variable "app_client_id" {
  type        = string
  default     = "test_client"
  description = "Id for the Keycloak client"
}

variable "app_client_secret" {
  type        = string
  default     = "secret"
  description = "Test client's secret"
}