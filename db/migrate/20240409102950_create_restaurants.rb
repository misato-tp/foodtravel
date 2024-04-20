class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.integer :postal_code, null: false
      t.string :address, null: false
      t.string :image
      t.float :latitude
      t.float :longitude
      t.text :memo
      t.timestamps
    end
  end
end
