# Page Object: Get available books (BookStore)
# All URLs and requests for this flow are in this file.
# DemoQA API: https://demoqa.com

import requests
from behave import given, when, then

# --- Paths (page object) ---
PATH_GET_BOOKS = "/BookStore/v1/Books"  # GET book list


def _url(context, path):
    return f"{context.base_url.rstrip('/')}{path}"


@when("I request the available books from the store")
def step_request_books(context):
    context.last_response = requests.get(
        _url(context, PATH_GET_BOOKS),
        headers={"accept": "application/json"},
        timeout=10,
    )


@then("the book list is returned successfully")
def step_book_list_ok(context):
    assert context.last_response.status_code == 200
    data = context.last_response.json()
    assert "books" in data, f"Response does not contain 'books': {data}"
    context.available_books = data["books"]
    assert len(context.available_books) >= 2, "At least 2 books are required to rent 2 random"
