class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :title
      t.string :image
      t.string :recommend
      t.string :memo

      t.timestamps
    end
  end
end
