# language: en
@check_character
Feature: Get character informations

    Feature Description: Search for first character

   Scenario: Get character name
    Given I search for the first character into Rick and Morty API
    When the request returs the result
    Then I can see the character name is "Rick Sanchez"

   Scenario: Get character status 
    Given I search for the first character into Rick and Morty API
    When the request returs the result
    Then I can see the character status should not be "Dead"
