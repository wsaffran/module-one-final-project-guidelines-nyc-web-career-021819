class UpdateActivitiesColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :activities, :type, :category
  end
end
