# Page Object: User details and collection books (Account)
# All URLs and requests for this flow are in this file.
# DemoQA API: https://demoqa.com

import requests
from behave import when, then

# --- Paths (page object) ---
PATH_GET_USER = "/Account/v1/User/{userId}"  # GET user + collection books


def _url(context, path):
    return f"{context.base_url.rstrip('/')}{path}"


@when("I fetch the created user details")
def step_fetch_user_details(context):
    path = PATH_GET_USER.format(userId=context.user_id)
    context.last_response = requests.get(
        _url(context, path),
        headers={
            "accept": "application/json",
            "Authorization": f"Bearer {context.token}",
        },
        timeout=10,
    )
    if context.last_response.status_code == 200:
        context.user_details = context.last_response.json()


@then("the user details are returned successfully")
def step_user_details_ok(context):
    assert context.last_response.status_code == 200, (
        f"Expected 200, got {context.last_response.status_code}: {context.last_response.text}"
    )
    context.user_details = context.last_response.json()
    assert "userId" in context.user_details or "userID" in context.user_details


@then("the user has exactly 2 books in the collection")
def step_user_has_2_books(context):
    books = context.user_details.get("books") or []
    assert len(books) == 2, f"Expected 2 books in collection, got: {len(books)}"


@then("the books in the collection are the ones that were added")
def step_books_match_added(context):
    books = context.user_details.get("books") or []
    isbns_in_collection = [b.get("isbn") for b in books if b.get("isbn")]
    for isbn in context.added_isbns:
        assert isbn in isbns_in_collection, f"ISBN {isbn} should be in collection: {isbns_in_collection}"
