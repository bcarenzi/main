require 'httparty'
require 'json'

Given('I search Rick location into Rick and Morty API') do
  # Doing the request to get the details of the character Rick Sanchez (ID 1)
  @response = HTTParty.get('https://rickandmortyapi.com/api/character/1')
  puts @response.body
end

When('I got the location from the request') do
  # Checking if the request was successful (code 200)
  expect(@response.code).to eql 200

  # Parsing the response body to access the data
  @character_data = JSON.parse(@response.body)

  # Storing the character location
  @character_location = @character_data['location']['name']
end

Then('I can see the location name') do
  # Checking if the location name exists and is not empty
  expect(@character_location).not_to be_nil
  expect(@character_location).not_to be_empty

  # Displaying the location in the console for debugging purposes
  puts "Rick Sanchez's location: #{@character_location}"
end