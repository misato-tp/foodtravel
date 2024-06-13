class Like < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user

  validates :user_id, presence: true
  validates :restaurant_id, presence: true
end
