require 'httparty'
require 'json'

Given('I search for Rick Sanchez in the Rick and Morty API') do
  # Fazendo a requisição para obter os detalhes do personagem Rick Sanchez (ID 1)
  @response = HTTParty.get('https://rickandmortyapi.com/api/character/1')
  puts @response.body
end

When('I retrieve the location information from the response') do
  # Verificando se a requisição foi bem-sucedida (código 200)
  expect(@response.code).to eql 200

  # Parseando o corpo da resposta para acessar os dados
  @character_data = JSON.parse(@response.body)

  # Armazenando a localização do personagem
  @character_location = @character_data['location']['name']
end

Then('I should see the correct location name') do
  # Verificando se a localização retornada é a esperada
  expect(@character_location).to eql('Citadel of Ricks')

  # Exibindo a localização no console para fins de depuração
  puts "Rick Sanchez's location: #{@character_location}"
end