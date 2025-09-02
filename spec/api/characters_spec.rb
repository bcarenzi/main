require 'spec_helper'

RSpec.describe 'API de Personagens', :vcr do
  describe 'GET /characters' do
    context 'quando a requisição é bem-sucedida' do
      it 'deve retornar uma lista de personagens' do
        # Arrange
        stub_request(:get, "#{api_url('characters')}")
          .to_return(
            status: 200,
            body: {
              characters: [
                { id: 1, name: 'Rick Sanchez', status: 'Alive' },
                { id: 2, name: 'Morty Smith', status: 'Alive' }
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # Act
        response = api_get('characters')

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data).to have_key('characters')
        expect(data['characters']).to be_an(Array)
        expect(data['characters'].length).to eq(2)
        
        # Validar estrutura do primeiro personagem
        first_character = data['characters'].first
        expect(first_character).to have_key('id')
        expect(first_character).to have_key('name')
        expect(first_character).to have_key('status')
      end
    end

    context 'quando há erro de autenticação' do
      it 'deve retornar status 401' do
        # Arrange
        stub_request(:get, "#{api_url('characters')}")
          .to_return(status: 401, body: { error: 'Unauthorized' }.to_json)

        # Act
        response = api_get('characters')

        # Assert
        expect(response.code).to eq(401)
        expect(client_error_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data).to have_key('error')
        expect(data['error']).to eq('Unauthorized')
      end
    end
  end

  describe 'GET /characters/:id' do
    context 'quando o personagem existe' do
      it 'deve retornar os detalhes do personagem' do
        # Arrange
        character_id = 1
        stub_request(:get, "#{api_url("characters/#{character_id}")}")
          .to_return(
            status: 200,
            body: {
              id: character_id,
              name: 'Rick Sanchez',
              status: 'Alive',
              species: 'Human',
              origin: 'Earth'
            }.to_json
          )

        # Act
        response = api_get("characters/#{character_id}")

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['id']).to eq(character_id)
        expect(data['name']).to eq('Rick Sanchez')
        expect(data['status']).to eq('Alive')
        expect(data['species']).to eq('Human')
        expect(data['origin']).to eq('Earth')
      end
    end

    context 'quando o personagem não existe' do
      it 'deve retornar status 404' do
        # Arrange
        character_id = 999
        stub_request(:get, "#{api_url("characters/#{character_id}")}")
          .to_return(status: 404, body: { error: 'Character not found' }.to_json)

        # Act
        response = api_get("characters/#{character_id}")

        # Assert
        expect(response.code).to eq(404)
        expect(client_error_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['error']).to eq('Character not found')
      end
    end
  end

  describe 'POST /characters' do
    context 'quando os dados são válidos' do
      it 'deve criar um novo personagem' do
        # Arrange
        new_character = generate_test_data(:user).merge(
          species: 'Alien',
          status: 'Alive'
        )
        
        stub_request(:post, "#{api_url('characters')}")
          .with(
            body: new_character.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(
            status: 201,
            body: new_character.merge(id: 3).to_json
          )

        # Act
        response = api_post('characters', new_character)

        # Assert
        expect(response.code).to eq(201)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data).to have_key('id')
        expect(data['name']).to eq(new_character[:name])
        expect(data['species']).to eq('Alien')
        expect(data['status']).to eq('Alive')
      end
    end

    context 'quando os dados são inválidos' do
      it 'deve retornar status 400' do
        # Arrange
        invalid_character = { name: '' } # Nome vazio é inválido
        
        stub_request(:post, "#{api_url('characters')}")
          .with(body: invalid_character.to_json)
          .to_return(
            status: 400,
            body: { error: 'Name is required' }.to_json
          )

        # Act
        response = api_post('characters', invalid_character)

        # Assert
        expect(response.code).to eq(400)
        expect(client_error_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['error']).to eq('Name is required')
      end
    end
  end

  describe 'PUT /characters/:id' do
    context 'quando a atualização é bem-sucedida' do
      it 'deve atualizar o personagem' do
        # Arrange
        character_id = 1
        update_data = { status: 'Dead', species: 'Zombie' }
        
        stub_request(:put, "#{api_url("characters/#{character_id}")}")
          .with(body: update_data.to_json)
          .to_return(
            status: 200,
            body: {
              id: character_id,
              name: 'Rick Sanchez',
              status: 'Dead',
              species: 'Zombie'
            }.to_json
          )

        # Act
        response = api_put("characters/#{character_id}", update_data)

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['id']).to eq(character_id)
        expect(data['status']).to eq('Dead')
        expect(data['species']).to eq('Zombie')
      end
    end
  end

  describe 'DELETE /characters/:id' do
    context 'quando a exclusão é bem-sucedida' do
      it 'deve excluir o personagem' do
        # Arrange
        character_id = 1
        stub_request(:delete, "#{api_url("characters/#{character_id}")}")
          .to_return(status: 204)

        # Act
        response = api_delete("characters/#{character_id}")

        # Assert
        expect(response.code).to eq(204)
        expect(successful_response?(response)).to be true
      end
    end
  end
end
