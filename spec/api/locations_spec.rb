require 'spec_helper'

RSpec.describe 'API de Localizações', :vcr do
  describe 'GET /locations' do
    context 'quando a requisição é bem-sucedida' do
      it 'deve retornar uma lista de localizações' do
        # Arrange
        stub_request(:get, "#{api_url('locations')}")
          .to_return(
            status: 200,
            body: {
              locations: [
                { id: 1, name: 'Earth', type: 'Planet', dimension: 'C-137' },
                { id: 2, name: 'Mars', type: 'Planet', dimension: 'C-137' }
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # Act
        response = api_get('locations')

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data).to have_key('locations')
        expect(data['locations']).to be_an(Array)
        expect(data['locations'].length).to eq(2)
        
        # Validar estrutura da primeira localização
        first_location = data['locations'].first
        expect(first_location).to have_key('id')
        expect(first_location).to have_key('name')
        expect(first_location).to have_key('type')
        expect(first_location).to have_key('dimension')
      end
    end

    context 'quando há filtros aplicados' do
      it 'deve retornar localizações filtradas por tipo' do
        # Arrange
        stub_request(:get, "#{api_url('locations')}?type=Planet")
          .to_return(
            status: 200,
            body: {
              locations: [
                { id: 1, name: 'Earth', type: 'Planet', dimension: 'C-137' }
              ]
            }.to_json
          )

        # Act
        response = api_get('locations?type=Planet')

        # Assert
        expect(response.code).to eq(200)
        data = JSON.parse(response.body)
        expect(data['locations'].length).to eq(1)
        expect(data['locations'].first['type']).to eq('Planet')
      end
    end
  end

  describe 'GET /locations/:id' do
    context 'quando a localização existe' do
      it 'deve retornar os detalhes da localização' do
        # Arrange
        location_id = 1
        stub_request(:get, "#{api_url("locations/#{location_id}")}")
          .to_return(
            status: 200,
            body: {
              id: location_id,
              name: 'Earth',
              type: 'Planet',
              dimension: 'C-137',
              residents: ['Rick Sanchez', 'Morty Smith']
            }.to_json
          )

        # Act
        response = api_get("locations/#{location_id}")

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['id']).to eq(location_id)
        expect(data['name']).to eq('Earth')
        expect(data['type']).to eq('Planet')
        expect(data['dimension']).to eq('C-137')
        expect(data['residents']).to be_an(Array)
        expect(data['residents']).to include('Rick Sanchez')
      end
    end

    context 'quando a localização não existe' do
      it 'deve retornar status 404' do
        # Arrange
        location_id = 999
        stub_request(:get, "#{api_url("locations/#{location_id}")}")
          .to_return(status: 404, body: { error: 'Location not found' }.to_json)

        # Act
        response = api_get("locations/#{location_id}")

        # Assert
        expect(response.code).to eq(404)
        expect(client_error_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['error']).to eq('Location not found')
      end
    end
  end

  describe 'POST /locations' do
    context 'quando os dados são válidos' do
      it 'deve criar uma nova localização' do
        # Arrange
        new_location = generate_test_data(:location).merge(
          type: 'Space Station',
          dimension: 'Unknown'
        )
        
        stub_request(:post, "#{api_url('locations')}")
          .with(
            body: new_location.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(
            status: 201,
            body: new_location.merge(id: 3).to_json
          )

        # Act
        response = api_post('locations', new_location)

        # Assert
        expect(response.code).to eq(201)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data).to have_key('id')
        expect(data['city']).to eq(new_location[:city])
        expect(data['type']).to eq('Space Station')
        expect(data['dimension']).to eq('Unknown')
      end
    end

    context 'quando os dados são inválidos' do
      it 'deve retornar status 400' do
        # Arrange
        invalid_location = { name: '', type: '' } # Campos obrigatórios vazios
        
        stub_request(:post, "#{api_url('locations')}")
          .with(body: invalid_location.to_json)
          .to_return(
            status: 400,
            body: { error: 'Name and type are required' }.to_json
          )

        # Act
        response = api_post('locations', invalid_location)

        # Assert
        expect(response.code).to eq(400)
        expect(client_error_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['error']).to eq('Name and type are required')
      end
    end
  end

  describe 'PUT /locations/:id' do
    context 'quando a atualização é bem-sucedida' do
      it 'deve atualizar a localização' do
        # Arrange
        location_id = 1
        update_data = { type: 'Space Station', dimension: 'C-999' }
        
        stub_request(:put, "#{api_url("locations/#{location_id}")}")
          .with(body: update_data.to_json)
          .to_return(
            status: 200,
            body: {
              id: location_id,
              name: 'Earth',
              type: 'Space Station',
              dimension: 'C-999'
            }.to_json
          )

        # Act
        response = api_put("locations/#{location_id}", update_data)

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['id']).to eq(location_id)
        expect(data['type']).to eq('Space Station')
        expect(data['dimension']).to eq('C-999')
      end
    end
  end

  describe 'DELETE /locations/:id' do
    context 'quando a exclusão é bem-sucedida' do
      it 'deve excluir a localização' do
        # Arrange
        location_id = 1
        stub_request(:delete, "#{api_url("locations/#{location_id}")}")
          .to_return(status: 204)

        # Act
        response = api_delete("locations/#{location_id}")

        # Assert
        expect(response.code).to eq(204)
        expect(successful_response?(response)).to be true
      end
    end
  end
end
