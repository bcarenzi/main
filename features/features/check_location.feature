# language: en
@check_location
Feature: Get charecter location 

    Feature Description: Search for Rick location

   Scenario: Get Rick location 
     Given I search Rick location into Rick and Morty API
     When I got the location from the request
     Then I can see the location name



