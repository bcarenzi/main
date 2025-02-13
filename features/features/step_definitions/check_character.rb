require 'httparty'
require 'json'

Given('I search for the first character in the Rick and Morty API') do
  # Fazendo a requisição para obter os detalhes do primeiro personagem (ID 1)
  @response = HTTParty.get('https://rickandmortyapi.com/api/character/1')
  puts @response.body
end

When('I retrieve the character details from the response') do
  # Verificando se a requisição foi bem-sucedida (código 200)
  expect(@response.code).to eql 200

  # Parseando o corpo da resposta para acessar os dados
  @character_data = JSON.parse(@response.body)

  # Armazenando o nome e o status do personagem
  @character_name = @character_data['name']
  @character_status = @character_data['status']
end

Then('I should see the character name as {string}') do |expected_name|
  # Verificando se o nome do personagem é o esperado
  expect(@character_name).to eql(expected_name)

  # Exibindo o nome do personagem no console para fins de depuração
  puts "Character name: #{@character_name}"
end

Then('the character status should not be {string}') do |unexpected_status|
  # Verificando se o status do personagem não é o valor inesperado
  expect(@character_status).not_to eql(unexpected_status)

  # Exibindo o status do personagem no console para fins de depuração
  puts "Character status: #{@character_status}"
end