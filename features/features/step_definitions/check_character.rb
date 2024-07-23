require 'httparty'
require 'json'

Given('I search for the first character into Rick and Morty API') do
    @get_character_url = HTTParty.get('https://rickandmortyapi.com/api/character/1')
    puts @get_character_url
    
  end
  
  When('the request returs the result') do
    expect(@get_character_url.code).to eql 200
  end

  Then('I can see the character name is {string}') do |string|
    
  end

  Then('I can see the character status should not be {string}') do |string|
    pending # Write code here that turns the phrase above into concrete actions
  end