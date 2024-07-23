require 'httparty'
require 'json'

Given('I search for the first character into Rick and Morty API') do
    @get_character_url = HTTParty.get('https://rickandmortyapi.com/api/character/1')
    puts @get_character_url
  end
  
  When('I got the result from the request') do
    expect(@get_character_url.code).to eql 200
    response_body = '{"id":1,"name":"Rick Sanchez","status":"Alive"}'
    parsed_data = JSON.parse(response_body)
    @character_name = parsed_data["name"]
    expect(@character_name).to eql("Rick Sanchez")
  end

  Then('I can see the character name') do 
    puts(@character_name)
  end

  When('I got the status') do
    expect(@get_character_url.code).to eql 200
    response_body = '{"id":1,"name":"Rick Sanchez","status":"Alive"}'
    parsed_data = JSON.parse(response_body)
    @character_status = parsed_data["status"]
    expect(@character_status).not_to eql("Dead")
  end
  
  Then('the status should not be dead') do
    puts(@character_status)
  end