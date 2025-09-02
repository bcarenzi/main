module ApiHelper
  # Configurações da API
  API_BASE_URL = ENV['API_BASE_URL'] || 'https://api.example.com'
  API_VERSION = ENV['API_VERSION'] || 'v1'
  
  # Headers padrão para requisições
  def default_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'User-Agent' => 'API-Test-Suite/1.0'
    }
  end
  
  # Headers com autenticação
  def auth_headers(token = nil)
    headers = default_headers
    headers['Authorization'] = "Bearer #{token || ENV['API_TOKEN']}"
    headers
  end
  
  # Construir URL da API
  def api_url(endpoint)
    "#{API_BASE_URL}/#{API_VERSION}/#{endpoint}"
  end
  
  # Fazer requisição GET
  def api_get(endpoint, headers = {})
    HTTParty.get(
      api_url(endpoint),
      headers: default_headers.merge(headers)
    )
  end
  
  # Fazer requisição POST
  def api_post(endpoint, body = {}, headers = {})
    HTTParty.post(
      api_url(endpoint),
      body: body.to_json,
      headers: default_headers.merge(headers)
    )
  end
  
  # Fazer requisição PUT
  def api_put(endpoint, body = {}, headers = {})
    HTTParty.put(
      api_url(endpoint),
      body: body.to_json,
      headers: default_headers.merge(headers)
    )
  end
  
  # Fazer requisição DELETE
  def api_delete(endpoint, headers = {})
    HTTParty.delete(
      api_url(endpoint),
      headers: default_headers.merge(headers)
    )
  end
  
  # Validar schema JSON
  def validate_json_schema(response, schema_file)
    schema = JSON.parse(File.read(schema_file))
    JSON::Validator.validate!(schema, response.body)
  end
  
  # Gerar dados de teste
  def generate_test_data(type)
    case type
    when :user
      {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        age: Faker::Number.between(from: 18, to: 80)
      }
    when :product
      {
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price,
        description: Faker::Lorem.sentence
      }
    when :location
      {
        city: Faker::Address.city,
        country: Faker::Address.country,
        coordinates: {
          lat: Faker::Address.latitude,
          lng: Faker::Address.longitude
        }
      }
    else
      {}
    end
  end
  
  # Verificar se a resposta é bem-sucedida
  def successful_response?(response)
    response.code.between?(200, 299)
  end
  
  # Verificar se a resposta é de erro do cliente
  def client_error_response?(response)
    response.code.between?(400, 499)
  end
  
  # Verificar se a resposta é de erro do servidor
  def server_error_response?(response)
    response.code.between?(500, 599)
  end
end

RSpec.configure do |config|
  config.include ApiHelper
end
