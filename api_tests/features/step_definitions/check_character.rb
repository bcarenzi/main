require 'httparty'
require 'json'

Given('I search for the first character into Rick and Morty API') do
  # Doing the request to get the details of the first character (ID 1)
  @response = HTTParty.get('https://rickandmortyapi.com/api/character/1')
  puts @response.body
end

When('I got the result from the request') do
  # Checking if the request was successful (code 200)
  expect(@response.code).to eql 200

  # Parsing the response body to access the data
  @character_data = JSON.parse(@response.body)

  # Storing the character name and status
  @character_name = @character_data['name']
  @character_status = @character_data['status']
end

Then('I can see the character name') do
  # Checking if the character name exists and is not empty
  expect(@character_name).not_to be_nil
  expect(@character_name).not_to be_empty

  # Displaying the character name in the console for debugging purposes
  puts "Character name: #{@character_name}"
end

When('I got the status') do
  # Checking if the request was successful (code 200)
  expect(@response.code).to eql 200

  # Parsing the response body to access the data
  @character_data = JSON.parse(@response.body) unless @character_data

  # Storing the character status
  @character_status = @character_data['status']
end

Then('the status should not be dead') do
  # Checking if the character status is not "Dead"
  expect(@character_status).not_to eql('Dead')

  # Displaying the character status in the console for debugging purposes
  puts "Character status: #{@character_status}"
end