require 'httparty'
require 'json'


Given('I search Rick location into Rick and Morty API') do
  @get_character_location = HTTParty.get('https://rickandmortyapi.com/api/character/1')
    puts @get_character_location
end

When('I got the location from the request') do
  expect(@get_character_location.code).to eql 200
  response_body = '{"id": 3,"name": "Citadel of Ricks","type": "Space station"}'
  parsed_data = JSON.parse(response_body)
  @character_location = parsed_data["name"]
  expect(@character_location).to eql("Citadel of Ricks")
end

Then('I can see the location name') do
 puts(@character_location)
end

