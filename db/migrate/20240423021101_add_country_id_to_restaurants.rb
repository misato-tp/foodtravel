class AddCountryIdToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_reference :restaurants, :country, foreign_key: true
  end
end
