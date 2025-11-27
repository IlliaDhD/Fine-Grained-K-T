# === Client roles ===
resource "keycloak_role" "admin" {
  name     = "admin"
  realm_id = keycloak_realm.realm.id
}

resource "keycloak_role" "editor" {
  name     = "editor"
  realm_id = keycloak_realm.realm.id
}

resource "keycloak_role" "viewer" {
  name     = "viewer"
  realm_id = keycloak_realm.realm.id
}

# === Test Users ===
resource "keycloak_user" "editor_user" {
  realm_id = keycloak_realm.realm.id
  username = "editor"
  email    = "editor@notexist.com"
  first_name = "Editor"
  last_name = "Editor"

  initial_password {
    value = "1234"
  }
}

resource "keycloak_user" "admin_user" {
  realm_id = keycloak_realm.realm.id
  username = "admin"
  email    = "admin@notexist.com"
  first_name = "Admin"
  last_name = "Admin"

  initial_password {
    value = "4321"
  }
}

resource "keycloak_user" "viewer_user" {
  realm_id = keycloak_realm.realm.id
  username = "viewer"
  email = "viewer@notexist.com"
  first_name = "Viewer"
  last_name = "Viewer"

  initial_password {
    value = "2222"
  }
}

# === User roles ===
resource "keycloak_user_roles" "editor_roles" {
  realm_id = keycloak_realm.realm.id
  role_ids = [keycloak_role.editor.id]
  user_id  = keycloak_user.editor_user.id
}

resource "keycloak_user_roles" "admin_roles" {
  realm_id = keycloak_realm.realm.id
  role_ids = [keycloak_role.admin.id]
  user_id  = keycloak_user.admin_user.id
}

resource "keycloak_user_roles" "viewer_roles" {
  realm_id = keycloak_realm.realm.id
  role_ids = [keycloak_role.viewer]
  user_id  = keycloak_user.viewer_user.id
}