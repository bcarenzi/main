Feature: Available books (BookStore)

  Scenario: Get the books list with success
    Given the BookStore is available
    When I request the available books from the store
    Then the book list is returned successfully
