# Behave hooks and context configuration
# https://behave.readthedocs.io/

import os
import requests


def before_all(context):
    """Runs once before all scenarios."""
    context.base_url = "https://demoqa.com"
    context.user_id = None
    context.username = None
    context.password = None
    # Password for test users: use env var in CI (GitHub Secrets), fallback for local
    context.test_password = os.environ.get("TEST_USER_PASSWORD", "Password123!")
    context.token = None
    context.last_response = None
    context.available_books = []
    context.added_isbns = []  # ISBNs of the 2 "rented" books
    context.user_details = None


def before_scenario(context, scenario):
    """Runs before each scenario: checks that the API is available."""
    try:
        url = f"{context.base_url.rstrip('/')}/BookStore/v1/Books"
        r = requests.get(url, timeout=10)
        context.api_ok = r.status_code in (200, 201)
    except Exception:
        context.api_ok = False
    assert context.api_ok, "BookStore API is not available"


def after_all(context):
    """Runs once after all scenarios."""
    pass
