class AddRatingColumnToUserActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :user_activities, :rating, :float
  end
end
