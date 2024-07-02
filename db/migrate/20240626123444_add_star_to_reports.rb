class AddStarToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :star, :string
  end
end
