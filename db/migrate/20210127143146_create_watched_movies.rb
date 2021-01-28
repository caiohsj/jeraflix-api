class CreateWatchedMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :watched_movies do |t|
      t.bigint :movie_id
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
