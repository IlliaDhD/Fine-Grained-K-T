# === Policies ===
resource "keycloak_openid_client_role_policy" "admin_policy" {
  name               = "admin_policy"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  type               = "role"
  decision_strategy  = "UNANIMOUS"
  logic              = "POSITIVE"

  role {
    id       = keycloak_role.admin.id
    required = false
  }
}

resource "keycloak_openid_client_role_policy" "editor_policy" {
  name               = "editor_policy"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  type               = "role"
  decision_strategy  = "UNANIMOUS"
  logic              = "POSITIVE"

  role {
    id       = keycloak_role.editor.id
    required = false
  }
}

resource "keycloak_openid_client_role_policy" "viewer_policy" {
  name               = "viewer_policy"
   realm_id          = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  type               = "role"
  decision_strategy  = "UNANIMOUS"
  logic              = "POSITIVE"

  role {
    id       = keycloak_role.viewer.id
    required = false
  }
}

# === Scopes ===
resource "keycloak_openid_client_authorization_scope" "view_scope" {
  name               = "view"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
}

resource "keycloak_openid_client_authorization_scope" "edit_scope" {
  name               = "edit"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
}

# === Resources ===
resource "keycloak_openid_client_authorization_resource" "editor_resource" {
  name               = "editor_resource"
  display_name       = "Editor resource"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  uris               = ["/data/*"]
  scopes             = [
    keycloak_openid_client_authorization_scope.view_scope.name,
    keycloak_openid_client_authorization_scope.view_scope.name
  ]
}

resource "keycloak_openid_client_authorization_resource" "admin_resource" {
  name               = "admin_resource"
  display_name       = "Admin resource"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  uris               = ["/admin-pannel"]
  owner_managed_access = true
  scopes = [keycloak_openid_client_authorization_scope.view_scope.name]
}

# === Permissions ===
resource "keycloak_openid_client_authorization_permission" "editor_permission" {
  name               = "editor-permission"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  resources          = [keycloak_openid_client_authorization_resource.editor_resource.id]
  policies           = [keycloak_openid_client_role_policy.editor_policy.id]
  scopes             = [
    keycloak_openid_client_authorization_scope.edit_scope.id,
    keycloak_openid_client_authorization_scope.view_scope.id
  ]
}

resource "keycloak_openid_client_authorization_permission" "admin_permission" {
  name               = "admin-permission"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  resources          = [
    keycloak_openid_client_authorization_resource.admin_resource.id,
    keycloak_openid_client_authorization_resource.editor_resource.id
  ]
  policies           = [keycloak_openid_client_role_policy.admin_policy.id]
  scopes             = [
    keycloak_openid_client_authorization_scope.view_scope.id,
    keycloak_openid_client_authorization_scope.edit_scope
  ]
}

resource "keycloak_openid_client_authorization_permission" "viewer_permission" {
  name               = "viewer-permission"
  realm_id           = keycloak_realm.realm.id
  resource_server_id = keycloak_openid_client.test_client.id
  resources          = [keycloak_openid_client_authorization_resource.editor_resource.id]
  policies           = [keycloak_openid_client_role_policy.viewer_policy.id]
  scopes             = [
    keycloak_openid_client_authorization_scope.view_scope.id
  ]
}

