require 'rspec/core/rake_task'
require 'rake'

# Configuração do RSpec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '--color --format documentation'
end

# Tarefa para executar testes específicos
RSpec::Core::RakeTask.new(:spec_api) do |t|
  t.pattern = 'spec/api/**/*_spec.rb'
  t.rspec_opts = '--color --format documentation'
end

# Tarefa para executar testes com VCR
RSpec::Core::RakeTask.new(:spec_vcr) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '--color --format documentation --tag vcr'
end

# Tarefa para limpar cassettes do VCR
task :clean_vcr do
  FileUtils.rm_rf('spec/fixtures/vcr_cassettes') if Dir.exist?('spec/fixtures/vcr_cassettes')
  puts "Cassettes do VCR removidos com sucesso!"
end

# Tarefa para instalar dependências
task :install_deps do
  puts "Instalando dependências..."
  system('bundle install')
  puts "Dependências instaladas com sucesso!"
end

# Tarefa para executar todos os testes
task :test => [:spec]

# Tarefa padrão
task :default => [:spec]

# Tarefa para executar testes com cobertura
RSpec::Core::RakeTask.new(:spec_with_coverage) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '--color --format documentation --format html --out coverage/rspec_results.html'
end

# Tarefa para executar testes de forma paralela (se disponível)
begin
  require 'parallel_tests'
  RSpec::Core::RakeTask.new(:spec_parallel) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = '--color --format progress'
  end
rescue LoadError
  puts "Parallel Tests não disponível. Execute 'gem install parallel_tests' para habilitar."
end
