require 'faker'

class CharacterFactory
  def self.create(attributes = {})
    default_attributes = {
      id: Faker::Number.between(from: 1, to: 1000),
      name: Faker::Name.name,
      status: ['Alive', 'Dead', 'unknown'].sample,
      species: ['Human', 'Alien', 'Robot', 'Animal'].sample,
      type: Faker::Lorem.word,
      gender: ['Female', 'Male', 'Genderless', 'unknown'].sample,
      origin: {
        name: Faker::Address.city,
        url: Faker::Internet.url
      },
      location: {
        name: Faker::Address.city,
        url: Faker::Internet.url
      },
      image: Faker::Internet.url,
      episode: Array.new(Faker::Number.between(from: 1, to: 5)) { Faker::Internet.url },
      url: Faker::Internet.url,
      created: Faker::Time.between(from: 2.years.ago, to: Time.now).iso8601
    }

    default_attributes.merge(attributes)
  end

  def self.create_list(count, attributes = {})
    Array.new(count) { create(attributes) }
  end

  def self.create_alive_character(attributes = {})
    create(attributes.merge(status: 'Alive'))
  end

  def self.create_dead_character(attributes = {})
    create(attributes.merge(status: 'Dead'))
  end

  def self.create_human_character(attributes = {})
    create(attributes.merge(species: 'Human'))
  end

  def self.create_alien_character(attributes = {})
    create(attributes.merge(species: 'Alien'))
  end

  def self.create_with_episodes(episode_count, attributes = {})
    episodes = Array.new(episode_count) { Faker::Internet.url }
    create(attributes.merge(episode: episodes))
  end
end
