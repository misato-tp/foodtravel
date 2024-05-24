class AddForeignKeyToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :restaurants, :countries
  end
end
