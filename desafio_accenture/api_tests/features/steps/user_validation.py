# Page Object: Validation / Authentication (Account)
# All URLs and requests for this flow are in this file.
# DemoQA API: https://demoqa.com

import json
import uuid
import requests
from behave import given, when, then

# --- Paths (page object) ---
PATH_GENERATE_TOKEN = "/Account/v1/GenerateToken"  # POST
PATH_AUTHORIZED = "/Account/v1/Authorized"          # POST
PATH_GET_USER = "/Account/v1/User/{userId}"         # GET


def _url(context, path):
    return f"{context.base_url.rstrip('/')}{path}"


@when("I fetch the created user by ID to validate")
def step_fetch_user_to_validate(context):
    path = PATH_GET_USER.format(userId=context.user_id)
    context.last_response = requests.get(
        _url(context, path),
        headers={
            "accept": "application/json",
            "Authorization": f"Bearer {context.token}",
        },
        timeout=10,
    )


@then("the returned data confirms the user was created")
def step_data_confirms_user_created(context):
    assert context.last_response.status_code == 200, (
        f"Expected 200, got {context.last_response.status_code}: {context.last_response.text}"
    )
    data = context.last_response.json()
    assert data.get("userId") == context.user_id or data.get("userID") == context.user_id
    assert data.get("username") == context.username or data.get("userName") == context.username


# --- Token (used in flow) ---

@when("I generate the auth token with the user credentials")
def step_generate_token(context):
    payload = {"userName": context.username, "password": context.password}
    context.last_response = requests.post(
        _url(context, PATH_GENERATE_TOKEN),
        json=payload,
        headers={"Content-Type": "application/json", "accept": "application/json"},
        timeout=10,
    )


@then("the token is generated successfully")
def step_token_ok(context):
    assert context.last_response.status_code == 200
    data = context.last_response.json()
    assert data.get("status") == "Success", f"Token status: {data}"
    assert "token" in data, f"Response does not contain token: {data}"
    context.token = data["token"]


# --- Token / Authorized (no body in feature; payload in step) ---

@when("I request to generate a token with valid credentials")
def step_request_generate_token(context):
    if getattr(context, "username", None) and getattr(context, "password", None):
        payload = {"userName": context.username, "password": context.password}
    else:
        context.username = f"test_user_{uuid.uuid4().hex[:8]}"
        context.password = getattr(context, "test_password", "Password123!")
        create = requests.post(
            _url(context, "/Account/v1/User"),
            json={"userName": context.username, "password": context.password},
            headers={"Content-Type": "application/json", "accept": "application/json"},
            timeout=10,
        )
        assert create.status_code == 201, f"Create user failed: {create.text}"
        payload = {"userName": context.username, "password": context.password}
    context.last_response = requests.post(
        _url(context, PATH_GENERATE_TOKEN),
        json=payload,
        headers={"Content-Type": "application/json", "accept": "application/json"},
        timeout=10,
    )


@when("I request to validate credentials (Authorized)")
def step_request_authorized(context):
    if getattr(context, "username", None) and getattr(context, "password", None):
        payload = {"userName": context.username, "password": context.password}
    else:
        context.username = f"test_user_{uuid.uuid4().hex[:8]}"
        context.password = getattr(context, "test_password", "Password123!")
        create = requests.post(
            _url(context, "/Account/v1/User"),
            json={"userName": context.username, "password": context.password},
            headers={"Content-Type": "application/json", "accept": "application/json"},
            timeout=10,
        )
        assert create.status_code == 201, f"Create user failed: {create.text}"
        payload = {"userName": context.username, "password": context.password}
    context.last_response = requests.post(
        _url(context, PATH_AUTHORIZED),
        json=payload,
        headers={"Content-Type": "application/json", "accept": "application/json"},
        timeout=10,
    )


@when('I make a POST request to "/Account/v1/GenerateToken" with:')
def step_post_generate_token_with_body(context):
    payload = json.loads(context.text) if context.text else {}
    context.last_response = requests.post(
        _url(context, PATH_GENERATE_TOKEN),
        json=payload,
        headers={"Content-Type": "application/json", "accept": "application/json"},
        timeout=10,
    )


@when('I make a POST request to "/Account/v1/Authorized" with:')
def step_post_authorized_with_body(context):
    payload = json.loads(context.text) if context.text else {}
    context.last_response = requests.post(
        _url(context, PATH_AUTHORIZED),
        json=payload,
        headers={"Content-Type": "application/json", "accept": "application/json"},
        timeout=10,
    )


@then("the status code should be 200")
def step_status_200(context):
    assert context.last_response.status_code == 200, (
        f"Expected 200, got {context.last_response.status_code}"
    )


@then('the response should contain "token"')
def step_response_contains_token(context):
    data = context.last_response.json()
    assert "token" in data, f"Response does not contain token: {data}"


@then('the response should contain "status" with value "Success"')
def step_response_status_success(context):
    data = context.last_response.json()
    assert data.get("status") == "Success", f"status: {data.get('status')}"


@then("the response body should be true")
def step_body_is_true(context):
    body = context.last_response.text.strip().lower()
    assert body == "true", f"Expected true, got: {context.last_response.text}"


@then("the credentials validation request returns successfully")
def step_authorized_returns_ok(context):
    assert context.last_response.status_code == 200
    body = context.last_response.text.strip().lower()
    assert body in ("true", "false"), f"Expected boolean body, got: {context.last_response.text}"
