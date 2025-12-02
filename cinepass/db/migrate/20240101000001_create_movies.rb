class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.date :watched_at, null: false
      t.integer :rating
      t.text :notes

      t.timestamps
    end
  end
end

