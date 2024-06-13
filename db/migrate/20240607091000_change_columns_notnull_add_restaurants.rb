class ChangeColumnsNotnullAddRestaurants < ActiveRecord::Migration[6.1]
  def change
    change_column :restaurants, :latitude, :float, null: false
    change_column :restaurants, :longitude, :float, null: false
    change_column :restaurants, :user_id, :integer, null: false
    change_column :restaurants, :country_id, :bigint, null: false
  end
end
