class RemoveForeignKeyFromRestaurants < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :restaurants, :countries
  end
end
