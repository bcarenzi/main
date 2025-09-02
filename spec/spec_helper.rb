require 'rspec'
require 'httparty'
require 'webmock/rspec'
require 'vcr'
require 'json-schema'
require 'faker'
require 'dotenv'

# Carregar arquivos de suporte
Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }

# Configuração do VCR para gravar e reproduzir requisições HTTP
VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<API_KEY>') { ENV['API_KEY'] }
  config.filter_sensitive_data('<AUTH_TOKEN>') { ENV['AUTH_TOKEN'] }
end

# Configuração do WebMock
WebMock.disable_net_connect!(allow_localhost: true)

# Configuração do RSpec
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  
  # Limpar mocks entre testes
  config.after(:each) do
    WebMock.reset!
  end
end

# Carregar variáveis de ambiente
Dotenv.load('env.test') if File.exist?('env.test')
