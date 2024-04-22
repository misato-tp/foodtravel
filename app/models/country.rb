class Country < ApplicationRecord
  validates :country_name, presence: true
end
