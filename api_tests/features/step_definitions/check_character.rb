require 'httparty'
require 'json'

Given('I search for the first character in the Rick and Morty API') do
  # Doing the request to get the details of the first character (ID 1)
  @response = HTTParty.get('https://rickandmortyapi.com/api/character/1')
  puts @response.body
end

When('I retrieve the character details from the response') do
  # Checking if the request was successful (code 200)
  expect(@response.code).to eql 200

  # Parsing the response body to access the data
  @character_data = JSON.parse(@response.body)

  # Storing the character name and status
  @character_name = @character_data['name']
  @character_status = @character_data['status']
end

Then('I should see the character name as {string}') do |expected_name|
  # Checking if the character name is the expected
  expect(@character_name).to eql(expected_name)

  # Displaying the character name in the console for debugging purposes
  puts "Character name: #{@character_name}"
end

Then('the character status should not be {string}') do |unexpected_status|
  # Checking if the character status is not the unexpected value
  expect(@character_status).not_to eql(unexpected_status)

  # Displaying the character status in the console for debugging purposes
  puts "Character status: #{@character_status}"
end