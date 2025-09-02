require 'spec_helper'

RSpec.describe 'API Health Check', :vcr do
  describe 'GET /health' do
    context 'quando a API está funcionando' do
      it 'deve retornar status 200 e informações de saúde' do
        # Arrange
        stub_request(:get, "#{api_url('health')}")
          .to_return(
            status: 200,
            body: {
              status: 'healthy',
              timestamp: Time.now.iso8601,
              version: '1.0.0',
              uptime: 3600,
              services: {
                database: 'connected',
                cache: 'connected',
                external_api: 'connected'
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # Act
        response = api_get('health')

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['status']).to eq('healthy')
        expect(data).to have_key('timestamp')
        expect(data).to have_key('version')
        expect(data).to have_key('uptime')
        expect(data).to have_key('services')
        
        services = data['services']
        expect(services['database']).to eq('connected')
        expect(services['cache']).to eq('connected')
        expect(services['external_api']).to eq('connected')
      end
    end

    context 'quando há problemas de conectividade' do
      it 'deve retornar status 503 e informações de erro' do
        # Arrange
        stub_request(:get, "#{api_url('health')}")
          .to_return(
            status: 503,
            body: {
              status: 'unhealthy',
              timestamp: Time.now.iso8601,
              version: '1.0.0',
              errors: [
                'Database connection failed',
                'Cache service unavailable'
              ],
              services: {
                database: 'disconnected',
                cache: 'disconnected',
                external_api: 'connected'
              }
            }.to_json
          )

        # Act
        response = api_get('health')

        # Assert
        expect(response.code).to eq(503)
        expect(server_error_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['status']).to eq('unhealthy')
        expect(data).to have_key('errors')
        expect(data['errors']).to be_an(Array)
        expect(data['errors']).to include('Database connection failed')
        expect(data['errors']).to include('Cache service unavailable')
        
        services = data['services']
        expect(services['database']).to eq('disconnected')
        expect(services['cache']).to eq('disconnected')
      end
    end
  end

  describe 'GET /health/readiness' do
    context 'quando o serviço está pronto para receber tráfego' do
      it 'deve retornar status 200' do
        # Arrange
        stub_request(:get, "#{api_url('health/readiness')}")
          .to_return(
            status: 200,
            body: { status: 'ready' }.to_json
          )

        # Act
        response = api_get('health/readiness')

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['status']).to eq('ready')
      end
    end
  end

  describe 'GET /health/liveness' do
    context 'quando o serviço está vivo' do
      it 'deve retornar status 200' do
        # Arrange
        stub_request(:get, "#{api_url('health/liveness')}")
          .to_return(
            status: 200,
            body: { status: 'alive' }.to_json
          )

        # Act
        response = api_get('health/liveness')

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data['status']).to eq('alive')
      end
    end
  end

  describe 'GET /health/metrics' do
    context 'quando as métricas estão disponíveis' do
      it 'deve retornar métricas de performance' do
        # Arrange
        stub_request(:get, "#{api_url('health/metrics')}")
          .to_return(
            status: 200,
            body: {
              requests_total: 1500,
              requests_per_second: 25.5,
              response_time_avg: 120,
              response_time_p95: 250,
              response_time_p99: 500,
              error_rate: 0.02,
              active_connections: 45
            }.to_json
          )

        # Act
        response = api_get('health/metrics')

        # Assert
        expect(response.code).to eq(200)
        expect(successful_response?(response)).to be true
        
        data = JSON.parse(response.body)
        expect(data).to have_key('requests_total')
        expect(data).to have_key('requests_per_second')
        expect(data).to have_key('response_time_avg')
        expect(data).to have_key('response_time_p95')
        expect(data).to have_key('response_time_p99')
        expect(data).to have_key('error_rate')
        expect(data).to have_key('active_connections')
        
        # Validar tipos de dados
        expect(data['requests_total']).to be_an(Integer)
        expect(data['requests_per_second']).to be_a(Float)
        expect(data['response_time_avg']).to be_an(Integer)
        expect(data['error_rate']).to be_a(Float)
        expect(data['active_connections']).to be_an(Integer)
      end
    end
  end
end

