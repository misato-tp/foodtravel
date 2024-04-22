class CreateRestaurantCountryRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurant_country_relations do |t|
      t.references :restaurant, foreign_key: true
      t.references :country, foreign_key: true
      t.timestamps
    end
  end
end
