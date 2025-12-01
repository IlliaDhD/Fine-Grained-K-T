# == Groups ==
resource "keycloak_group" "admin_group" {
  name     = "admin_group"
  realm_id = keycloak_realm.realm.id
}

# == Group Roles ==
resource "keycloak_group_roles" "admin_group_roles" {
  group_id = keycloak_group.admin_group.id
  realm_id = keycloak_realm.realm.id
  role_ids = [keycloak_role.admin.id]
}

# == Group Members ==
resource "keycloak_group_memberships" "admin_group_memberships" {
  members = [
    keycloak_user.full_admin.username,
    keycloak_user.admin_user.username
  ]

  group_id = keycloak_group.admin_group.id
  realm_id = keycloak_realm.realm.id
}