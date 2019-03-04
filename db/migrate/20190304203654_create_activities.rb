class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.float :accessibility
      t.string :category
      t.integer :participants
      t.float :price
    end
  end
end
