import os, requests, logging

from flask import Flask, request

# Creates Flask application
app = Flask(__name__)

# === Environmental Variables ===
KEYCLOAK_HOST = os.getenv("KEYCLOAK_HOST")
REALM = os.getenv("REALM_NAME")
CLIENT_ID = os.getenv("CLIENT_ID")
PRM_TOKEN_URL = f"{KEYCLOAK_HOST}/realms/{REALM}/protocol/openid-connect/token"

# === Logger Initialization ===
logging.basicConfig(
        level=logging.INFO,
        format="[%(levelname)s] %(message)s"
    )
logger = logging.getLogger(__name__)

def check_permission(access_token: str, resource: str, scope: str):
    """"
    Makes a request to the Keycloak API to check if the user have access.
    Keycloak returns a successful response if the user have an access, otherwise 403 error is returned.

    :param access_token: User's access token
    :param resource: Accessed resource
    :param scope: Optional scope value
    :returns: True or False
    """

    # === Request Body Initialization ===
    data = {
        "grant_type": "urn:ietf:params:oauth:grant-type:uma-ticket",
        "audience": CLIENT_ID,
        "response_mode": "decision",
        "permission": f"{resource}#{scope}"
    }

    # === Request Headers Initialization ===
    headers = {
        "Authorization":  access_token,
        "Content-Type": "application/x-www-form-urlencoded"
    }

    try:
        response = requests.post(PRM_TOKEN_URL, headers=headers, data=data)
        response.raise_for_status()

    except requests.exceptions.HTTPError  as e:
        if e.response.status_code == 401:
            logger.error(f"Access token is invalid: {e.response.json()}")
        elif e.response.status_code == 403:
            logger.error(f"User does not have permission to access the resource: {e.response.json()}")
        else:
            logger.error(f"Failed to get access token: {e.response.status_code} {e.response.json()}")
        return False

    return bool(response.json()["result"])

def __extract_token():
    return request.headers.get("Authorization")


# ---------------------------
# Public API without authorization
# ---------------------------
@app.route("/public")
def public():
    return {"message": "Public OK"}


# ---------------------------
# API requires at least viewer role
# ---------------------------
@app.route("/data")
def read_data():
    token = __extract_token()
    if not token:
        return {"error": "Missing token"}, 401

    allowed = check_permission(token, resource="editor_resource", scope="view")

    if not allowed:
        return {"error": "The user must be a viewer"}, 403

    return {"message": "You can VIEW data"}


# ---------------------------
# API requires at least editor role
# ---------------------------
@app.route("/data/update")
def update_data():
    token = __extract_token()
    if not token:
        return {"error": "Missing token"}, 401

    allowed = check_permission(token, resource="editor_resource", scope="edit")

    if not allowed:
        return {"error": "The user needs editor's permission to access the resource."}, 403

    return {"message": "You can EDIT data"}

# ---------------------------
# Admin's API
# ---------------------------
@app.route("/admin-panel")
def admin_panel():
    token = __extract_token()
    if not token:
        return {"error": "Missing token"}, 401

    allowed = check_permission(token, resource="admin_resource", scope="view")

    if not allowed:
        return {"error": "The user needs admin's role to access the resource."}, 403

    return {"message": "Welcome to Admin Panel"}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
