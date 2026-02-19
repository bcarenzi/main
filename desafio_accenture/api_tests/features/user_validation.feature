Feature: Authentication (Account)

  Scenario: Generate token with valid credentials
    Given the Account API is available
    When I request to generate a token with valid credentials
    Then the status code should be 200
    And the response should contain "token"
    And the response should contain "status" with value "Success"

  Scenario: Validate credentials (Authorized)
    Given the Account API is available
    When I request to validate credentials (Authorized)
    Then the credentials validation request returns successfully
