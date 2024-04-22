class Country < ApplicationRecord
  has_many :restaurant_country_relations
  has_many :restaurants, through: :restaurant_country_relations

  validates :name, presence: true
end
