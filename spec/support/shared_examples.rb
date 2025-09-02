# Exemplos compartilhados para testes de API

RSpec.shared_examples 'endpoint com autenticação' do |http_method, endpoint|
  context 'quando não há token de autenticação' do
    it 'deve retornar status 401' do
      # Arrange
      stub_request(http_method.downcase.to_sym, "#{api_url(endpoint)}")
        .to_return(status: 401, body: { error: 'Token required' }.to_json)

      # Act
      response = case http_method.upcase
                 when 'GET'
                   api_get(endpoint)
                 when 'POST'
                   api_post(endpoint, {})
                 when 'PUT'
                   api_put(endpoint, {})
                 when 'DELETE'
                   api_delete(endpoint)
                 end

      # Assert
      expect(response.code).to eq(401)
      expect(client_error_response?(response)).to be true
      
      data = JSON.parse(response.body)
      expect(data['error']).to eq('Token required')
    end
  end

  context 'quando o token é inválido' do
    it 'deve retornar status 403' do
      # Arrange
      stub_request(http_method.downcase.to_sym, "#{api_url(endpoint)}")
        .with(headers: { 'Authorization' => 'Bearer invalid_token' })
        .to_return(status: 403, body: { error: 'Invalid token' }.to_json)

      # Act
      response = case http_method.upcase
                 when 'GET'
                   api_get(endpoint, auth_headers('invalid_token'))
                 when 'POST'
                   api_post(endpoint, {}, auth_headers('invalid_token'))
                 when 'PUT'
                   api_put(endpoint, {}, auth_headers('invalid_token'))
                 when 'DELETE'
                   api_delete(endpoint, auth_headers('invalid_token'))
                 end

      # Assert
      expect(response.code).to eq(403)
      expect(client_error_response?(response)).to be true
      
      data = JSON.parse(response.body)
      expect(data['error']).to eq('Invalid token')
    end
  end
end

RSpec.shared_examples 'endpoint com validação de schema' do |endpoint, schema_file|
  it 'deve retornar resposta com schema válido' do
    # Arrange
    stub_request(:get, "#{api_url(endpoint)}")
      .to_return(
        status: 200,
        body: File.read(schema_file),
        headers: { 'Content-Type' => 'application/json' }
      )

    # Act
    response = api_get(endpoint)

    # Assert
    expect(response.code).to eq(200)
    expect { validate_json_schema(response, schema_file) }.not_to raise_error
  end
end

RSpec.shared_examples 'endpoint com rate limiting' do |http_method, endpoint|
  context 'quando o limite de requisições é excedido' do
    it 'deve retornar status 429' do
      # Arrange
      stub_request(http_method.downcase.to_sym, "#{api_url(endpoint)}")
        .to_return(
          status: 429,
          body: { error: 'Rate limit exceeded', retry_after: 60 }.to_json,
          headers: { 'Retry-After' => '60' }
        )

      # Act
      response = case http_method.upcase
                 when 'GET'
                   api_get(endpoint)
                 when 'POST'
                   api_post(endpoint, {})
                 when 'PUT'
                   api_put(endpoint, {})
                 when 'DELETE'
                   api_delete(endpoint)
                 end

      # Assert
      expect(response.code).to eq(429)
      expect(client_error_response?(response)).to be true
      
      data = JSON.parse(response.body)
      expect(data['error']).to eq('Rate limit exceeded')
      expect(data['retry_after']).to eq(60)
      expect(response.headers['Retry-After']).to eq('60')
    end
  end
end

RSpec.shared_examples 'endpoint com paginação' do |endpoint|
  context 'quando há múltiplas páginas' do
    it 'deve retornar dados paginados' do
      # Arrange
      stub_request(:get, "#{api_url(endpoint)}?page=1&per_page=10")
        .to_return(
          status: 200,
          body: {
            data: Array.new(10) { |i| { id: i + 1, name: "Item #{i + 1}" } },
            pagination: {
              current_page: 1,
              total_pages: 3,
              total_count: 25,
              per_page: 10
            }
          }.to_json
        )

      # Act
      response = api_get("#{endpoint}?page=1&per_page=10")

      # Assert
      expect(response.code).to eq(200)
      expect(successful_response?(response)).to be true
      
      data = JSON.parse(response.body)
      expect(data).to have_key('data')
      expect(data).to have_key('pagination')
      
      pagination = data['pagination']
      expect(pagination['current_page']).to eq(1)
      expect(pagination['total_pages']).to eq(3)
      expect(pagination['total_count']).to eq(25)
      expect(pagination['per_page']).to eq(10)
      
      expect(data['data'].length).to eq(10)
    end
  end
end

RSpec.shared_examples 'endpoint com cache' do |endpoint|
  it 'deve incluir headers de cache apropriados' do
    # Arrange
    stub_request(:get, "#{api_url(endpoint)}")
      .to_return(
        status: 200,
        body: { data: 'cached_data' }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Cache-Control' => 'public, max-age=3600',
          'ETag' => '"abc123"',
          'Last-Modified' => 'Wed, 21 Oct 2023 07:28:00 GMT'
        }
      )

    # Act
    response = api_get(endpoint)

    # Assert
    expect(response.code).to eq(200)
    expect(response.headers['Cache-Control']).to eq('public, max-age=3600')
    expect(response.headers['ETag']).to eq('"abc123"')
    expect(response.headers['Last-Modified']).to eq('Wed, 21 Oct 2023 07:28:00 GMT')
  end
end
