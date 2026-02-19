# Page Object: Create user (Account)
# All URLs and requests for this flow are in this file.
# DemoQA API: https://demoqa.com

import json
import uuid # to create a unique username for the user
import requests
from behave import given, when, then

# --- Paths (page object) ---
PATH_CHECK_API = "/BookStore/v1/Books"  # GET to check if API is up
PATH_CREATE_USER = "/Account/v1/User"   # POST create user

# this function is used to get the full URL of the API
def _url(context, path):
    return f"{context.base_url.rstrip('/')}{path}"


@when("I insert the user name and password")
@when("I request the API to create a new user with:")
@when('I create a new user with name "{username}" and password "{password}"')
def step_create_user_request(context, username=None, password=None):
    if username is not None and password is not None:
        # Create a unique username for the user
        context.username = f"{username}_{uuid.uuid4().hex[:8]}"
        context.password = password
        # Create the payload for the request
        payload = {"userName": context.username, "password": context.password}
    
    elif context.text:
        # Create the payload for the request from the context text
        payload = json.loads(context.text)
        context.username = payload.get("userName", "")
        context.password = payload.get("password", "")
    else:
        # Create a default username and password for the user if not provided
        default_password = getattr(context, "test_password", "Password123!")
        payload = {"userName": "test_user", "password": default_password}
        context.username = payload.get("userName", "") # Get the username from the payload
        context.password = payload.get("password", "") # Get the password from the payload
    # Send the request to the API to create the user
    context.last_response = requests.post(
        _url(context, PATH_CREATE_USER),
        json=payload,
        headers={"Content-Type": "application/json", "accept": "application/json"},
        # Set the timeout for the request to 10 seconds
        timeout=10,
    )
    # Check if the request was successful
    assert context.last_response.status_code == 201, (
        f"Expected 201, got {context.last_response.status_code}: {context.last_response.text}"
    )


@then("the status code should be 201")
def step_status_201(context):
    assert context.last_response.status_code == 201, (
        f"Expected 201, got {context.last_response.status_code}: {context.last_response.text}"
    )


@then('the response should contain "userID"')
def step_response_contains_user_id(context):
    data = context.last_response.json()
    assert "userID" in data, f"Response does not contain userID: {data}"
    context.user_id = data["userID"]


@then("the user is created successfully")
def step_user_created_successfully(context):
    assert context.last_response.status_code == 201
    data = context.last_response.json()
    assert "userID" in data
    context.user_id = data["userID"]
