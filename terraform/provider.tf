terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "= 5.3.0"
    }
  }
}

provider "keycloak" {
  client_id     = var.provider_client_id
  client_secret = var.provider_client_secret
  url           = var.keycloak_url
}