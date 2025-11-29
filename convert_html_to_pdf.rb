#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to convert HTML file to PDF using Ruby

require 'pathname'

# Add Node.js to PATH if not already there
node_paths = [
  '/opt/homebrew/opt/node/bin',
  '/opt/homebrew/bin',
  '/usr/local/bin'
]
node_paths.each do |path|
  ENV['PATH'] = "#{path}:#{ENV['PATH']}" if Dir.exist?(path)
end

require 'grover'

def convert_html_to_pdf(html_file, pdf_file)
  html_path = Pathname.new(html_file).expand_path
  pdf_path = Pathname.new(pdf_file).expand_path
  
  # Read HTML content
  html_content = File.read(html_path)
  
  # Configure PDF options
  grover = Grover.new(html_content, format: 'A4', margin: {
    top: '0.75in',
    right: '0.75in',
    bottom: '0.75in',
    left: '0.75in'
  })
  
  # Generate PDF
  pdf = grover.to_pdf
  
  # Write PDF file
  File.write(pdf_path, pdf)
  
  puts "✅ File converted successfully: #{pdf_path}"
rescue LoadError
  puts "❌ grover gem not found. Installing..."
  puts "   This may take a few moments..."
  
  system('bundle add grover')
  system('bundle install')
  
  # Retry after installation
  require 'grover'
  convert_html_to_pdf(html_file, pdf_file)
rescue => e
  puts "❌ Conversion error: #{e.message}"
  puts "\n💡 Alternative: Open the HTML file in your browser and use Cmd+P to save as PDF"
  puts "   Or try installing grover manually:"
  puts "   bundle add grover"
  puts "   bundle install"
end

def main
  # Get HTML file from command line argument or use default
  current_dir = Pathname.new(__FILE__).dirname
  
  html_file = if ARGV.length > 0
                # Use file provided as argument
                file = Pathname.new(ARGV[0])
                file.absolute? ? file : current_dir / file
              else
                # Default: use rspec_results.html
                current_dir / 'rspec_results.html'
              end
  
  # Check if HTML file exists
  unless html_file.exist?
    puts "❌ HTML file not found: #{html_file}"
    puts "\nUsage: ruby #{File.basename(__FILE__)} [html_file]"
    puts "Example: ruby #{File.basename(__FILE__)} rspec_results.html"
    exit 1
  end
  
  # Generate PDF filename (same name but with .pdf extension)
  pdf_file = html_file.sub_ext('.pdf')
  
  puts "📄 Converting: #{html_file}"
  puts "📁 To: #{pdf_file}"
  
  # Convert the file
  convert_html_to_pdf(html_file.to_s, pdf_file.to_s)
end

main if __FILE__ == $PROGRAM_NAME

