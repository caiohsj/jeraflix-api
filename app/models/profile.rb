class Profile < ApplicationRecord
  belongs_to :user
  has_many :watchlist, dependent: :destroy
end
