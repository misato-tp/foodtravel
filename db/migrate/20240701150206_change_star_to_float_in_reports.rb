class ChangeStarToFloatInReports < ActiveRecord::Migration[6.1]
  def change
    change_column :reports, :star, 'float USING star::double precision'
  end
end
