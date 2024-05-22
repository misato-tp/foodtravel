class Report < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :memo, presence: true
end
