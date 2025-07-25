# Rick and Morty API Testing Project

This project contains automated tests for the [Rick and Morty API](https://rickandmortyapi.com/) using Cucumber and Ruby.

## 🚀 Features

- **Character Testing**: Verify character information and details
- **Location Testing**: Validate character location data
- **API Integration**: Direct integration with the Rick and Morty API
- **BDD Approach**: Tests written in Gherkin syntax for better readability

## 📋 Prerequisites

- **Ruby** (version 2.7 or higher recommended)
- **Bundler** (for dependency management)

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd main
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

## 🧪 Running Tests

### Run all tests
```bash
bundle exec cucumber
```

### Run specific feature files
```bash
# Run character tests
bundle exec cucumber features/features/check_character.feature

# Run location tests
bundle exec cucumber features/features/check_location.feature
```

### Run with verbose output
```bash
bundle exec cucumber --format pretty
```

## 📁 Project Structure

```
main/
├── features/
│   └── features/
│       ├── check_character.feature    # Character validation tests
│       ├── check_location.feature     # Location validation tests
│       ├── step_definitions/
│       │   ├── check_character.rb     # Character test steps
│       │   └── check_location.rb      # Location test steps
│       └── support/
│           └── env.rb                 # Test environment setup
├── Gemfile                            # Ruby dependencies
├── Gemfile.lock                       # Locked dependency versions
└── README.md                          # This file
```

## 🔧 Dependencies

- **cucumber**: BDD testing framework
- **httparty**: HTTP client for API requests
- **json**: JSON parsing utilities
- **rspec-expectations**: Assertion library

## 📝 Test Scenarios

### Character Tests (`check_character.feature`)
- Validates character information retrieval
- Checks character details like name, status, and species
- Verifies API response structure

### Location Tests (`check_location.feature`)
- Tests character location data
- Validates location name accuracy
- Ensures proper API response handling

## 🐛 Troubleshooting

### Common Issues

1. **Ruby version issues**
   ```bash
   # Check your Ruby version
   ruby --version
   
   # If you need to install/update Ruby, consider using rbenv or rvm
   ```

2. **Bundle install fails**
   ```bash
   # Update bundler
   gem update bundler
   
   # Clear gem cache
   bundle clean --force
   ```

3. **API connection issues**
   - Ensure you have internet connection
   - Check if the Rick and Morty API is accessible
   - Verify no firewall restrictions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🔗 Useful Links

- [Rick and Morty API Documentation](https://rickandmortyapi.com/documentation)
- [Cucumber Documentation](https://cucumber.io/docs)
- [HTTParty Documentation](https://github.com/jnunemaker/httparty)

## 📞 Support

If you encounter any issues or have questions, please open an issue in the repository.

