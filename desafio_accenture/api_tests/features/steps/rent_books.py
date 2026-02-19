# Page Object: Add books to collection (BookStore)
# All URLs and requests for this flow are in this file.
# DemoQA API: https://demoqa.com

import random
import uuid
import requests
from behave import given, when, then

# --- Paths (page object) ---
PATH_CHECK_API = "/BookStore/v1/Books"  # GET to check if API is up
PATH_ADD_BOOKS_TO_COLLECTION = "/BookStore/v1/Books"  # POST (Authorization: Bearer)
PATH_CREATE_USER = "/Account/v1/User"
PATH_GENERATE_TOKEN = "/Account/v1/GenerateToken"
PATH_GET_BOOKS = "/BookStore/v1/Books"

DEFAULT_ISBN = "9781449325862" # ISBN of the book to be added to the user collection

# this function is used to get the full URL of the API
def _url(context, path):
    return f"{context.base_url.rstrip('/')}{path}"


# this function is used to get the test password from the context
def _test_password(context):
    return getattr(context, "test_password", "Password123!")

# this step is used to create a new user with a valid token
@given("I have a valid token")
def step_have_valid_token(context):
    context.username = f"rent_user_{uuid.uuid4().hex[:8]}"
    context.password = _test_password(context)
    # Create the payload for the request
    payload = {"userName": context.username, "password": context.password}
    create = requests.post(
        _url(context, PATH_CREATE_USER),
        json={"userName": context.username, "password": context.password},
        headers={"Content-Type": "application/json", "accept": "application/json"},
        timeout=10,
    )
    assert create.status_code == 201, f"Create user failed: {create.text}"
    context.user_id = create.json()["userID"]
    token_resp = requests.post(
        _url(context, PATH_GENERATE_TOKEN),
        json={"userName": context.username, "password": context.password},
        headers={"Content-Type": "application/json", "accept": "application/json"},
        timeout=10,
    )
    assert token_resp.status_code == 200 and token_resp.json().get("status") == "Success"
    context.token = token_resp.json()["token"]


@given("I have a valid userId")
def step_have_valid_user_id(context):
    if not getattr(context, "user_id", None):
        context.username = context.username or f"rent_user_{uuid.uuid4().hex[:8]}"
        context.password = context.password or _test_password(context)
        create = requests.post(
            _url(context, PATH_CREATE_USER),
            json={"userName": context.username, "password": context.password},
            headers={"Content-Type": "application/json", "accept": "application/json"},
            timeout=10,
        )
        assert create.status_code == 201
        context.user_id = create.json()["userID"]
    assert context.user_id


@when("I add a book to the user collection")
def step_add_one_book(context):
    payload = {
        "userId": context.user_id,
        "collectionOfIsbns": [{"isbn": DEFAULT_ISBN}],
    }
    context.last_response = requests.post(
        _url(context, PATH_ADD_BOOKS_TO_COLLECTION),
        json=payload,
        headers={
            "Content-Type": "application/json",
            "accept": "application/json",
            "Authorization": f"Bearer {context.token}",
        },
        timeout=10,
    )


@when("I add 2 random books to the user collection")
def step_add_2_random_books(context):
    books = context.available_books
    two = random.sample(books, 2)
    context.added_isbns = [book["isbn"] for book in two]
    payload = {
        "userId": context.user_id,
        "collectionOfIsbns": [{"isbn": isbn} for isbn in context.added_isbns],
    }
    context.last_response = requests.post(
        _url(context, PATH_ADD_BOOKS_TO_COLLECTION),
        json=payload,
        headers={
            "Content-Type": "application/json",
            "accept": "application/json",
            "Authorization": f"Bearer {context.token}",
        },
        timeout=10,
    )


@then("the books are added to the collection successfully")
def step_books_added_ok(context):
    assert context.last_response.status_code == 201, (
        f"Expected 201, got {context.last_response.status_code}: {context.last_response.text}"
    )
