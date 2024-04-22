class RestaurantCountryRelation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :country
end
