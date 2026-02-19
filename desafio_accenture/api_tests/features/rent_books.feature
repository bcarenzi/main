Feature: Add books to collection (BookStore)

  Scenario: Add book to user collection
    Given I have a valid token
    And I have a valid userId
    When I add a book to the user collection
    Then the books are added to the collection successfully
