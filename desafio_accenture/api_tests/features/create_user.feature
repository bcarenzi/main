Feature: Create user (Account)

# to run behave features/create_user.feature


  Scenario: Create user successfully
    Given the BookStore API is available
    When I create a new user with name "test_user" and password "Password123!"
    Then the status code should be 201
    And the response should contain "userID"
