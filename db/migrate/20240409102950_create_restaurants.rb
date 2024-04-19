class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.integer :postal_code, null: false
      t.string :prefecture_code, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :other_address
      t.string :image
      t.text :memo

      t.timestamps
    end
  end
end
