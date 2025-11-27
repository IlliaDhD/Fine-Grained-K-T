# === Realm ===
resource "keycloak_realm" "realm" {
  realm             = var.realm_name
  enabled           = true
  display_name      = var.realm_name

  sso_session_max_lifespan = "12h0m0s"
  access_token_lifespan    = "10m0s"

  login_with_email_allowed = true
}

# === OpenID client ===
resource "keycloak_openid_client" "test_client" {
  access_type = "CONFIDENTIAL"
  client_id   = var.app_client_id
  name        = "test client"
  realm_id    = keycloak_realm.realm.id
  client_secret = var.app_client_secret
  service_accounts_enabled = true
  standard_flow_enabled = true
  direct_access_grants_enabled = true

  valid_redirect_uris = [
    "*",
  ]

  authorization {
    policy_enforcement_mode = "ENFORCING"
  }
}