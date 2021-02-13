class Profile < ApplicationRecord
  belongs_to :user
  has_many :watchlist, dependent: :destroy
  has_many :watched_movies, dependent: :destroy
  has_many :favorite_list, dependent: :destroy
end
