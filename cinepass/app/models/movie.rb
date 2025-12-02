class Movie < ApplicationRecord
  validates :title, presence: true
  validates :rating, inclusion: { in: 1..5, message: "deve ser entre 1 e 5 estrelas" }, allow_nil: true
  validates :watched_at, presence: true

  def self.export_to_json
    all.map do |movie|
      {
        id: movie.id,
        title: movie.title,
        watched_at: movie.watched_at,
        rating: movie.rating,
        notes: movie.notes,
        created_at: movie.created_at,
        updated_at: movie.updated_at
      }
    end.to_json
  end
end

