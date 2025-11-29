# language: en
@check_character
Feature: Get character informations

    Feature Description: Search for first character
    Background: Given I search for the first character into Rick and Morty API

   Scenario: Get character name
     When I got the result from the request
     Then I can see the character name

   Scenario: Rick should not be dead
     When I got the status 
     Then the status should not be dead


