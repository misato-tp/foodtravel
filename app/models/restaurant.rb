class Restaurant < ApplicationRecord
  validates :name, :address, presence: true
  validates :address, uniqueness: true
end
