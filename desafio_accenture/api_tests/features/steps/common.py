# Steps to be used in all features
# The real API check is done in environment.py (before_scenario).
# These steps only confirm that the check passed.

from behave import given


@given("the BookStore API is available")
@given("the DemoQA API is available")
@given("the BookStore is available")
@given("the Account API is available")
def step_api_available(context):
    """Check already done in before_scenario; just validate the result."""
    assert getattr(context, "api_ok", False), "API is not available"
