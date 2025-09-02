require 'faker'

class LocationFactory
  def self.create(attributes = {})
    default_attributes = {
      id: Faker::Number.between(from: 1, to: 1000),
      name: Faker::Address.city,
      type: ['Planet', 'Space Station', 'Spacecraft', 'City', 'Country'].sample,
      dimension: Faker::Lorem.word,
      residents: Array.new(Faker::Number.between(from: 0, to: 10)) { Faker::Internet.url },
      url: Faker::Internet.url,
      created: Faker::Time.between(from: 2.years.ago, to: Time.now).iso8601
    }

    default_attributes.merge(attributes)
  end

  def self.create_list(count, attributes = {})
    Array.new(count) { create(attributes) }
  end

  def self.create_planet(attributes = {})
    create(attributes.merge(type: 'Planet'))
  end

  def self.create_space_station(attributes = {})
    create(attributes.merge(type: 'Space Station'))
  end

  def self.create_spacecraft(attributes = {})
    create(attributes.merge(type: 'Spacecraft'))
  end

  def self.create_city(attributes = {})
    create(attributes.merge(type: 'City'))
  end

  def self.create_with_residents(resident_count, attributes = {})
    residents = Array.new(resident_count) { Faker::Internet.url }
    create(attributes.merge(residents: residents))
  end

  def self.create_earth_location(attributes = {})
    create(attributes.merge(
      name: 'Earth',
      type: 'Planet',
      dimension: 'C-137'
    ))
  end

  def self.create_mars_location(attributes = {})
    create(attributes.merge(
      name: 'Mars',
      type: 'Planet',
      dimension: 'C-137'
    ))
  end
end
