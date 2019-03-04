class CreateUserActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :user_activities do |t|
      t.integer :user_id
      t.integer :activity_id
    end
  end
end
