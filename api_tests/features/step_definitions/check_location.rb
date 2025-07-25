require 'httparty'
require 'json'

Given('I search for Rick Sanchez in the Rick and Morty API') do
  # Doing the request to get the details of the character Rick Sanchez (ID 1)
  @response = HTTParty.get('https://rickandmortyapi.com/api/character/1')
  puts @response.body
end

When('I retrieve the location information from the response') do
  # Checking if the request was successful (code 200)
  expect(@response.code).to eql 200

  # Parsing the response body to access the data
  @character_data = JSON.parse(@response.body)

  # Storing the character location
  @character_location = @character_data['location']['name']
end

Then('I should see the correct location name') do
  # Checking if the returned location is the expected
  expect(@character_location).to eql('Citadel of Ricks')

  # Displaying the location in the console for debugging purposes
  puts "Rick Sanchez's location: #{@character_location}"
end