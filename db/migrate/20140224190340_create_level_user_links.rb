class CreateLevelUserLinks < ActiveRecord::Migration
  def change
    create_table :level_user_links do |t|
      t.integer :user_id
      t.integer :level_id
      t.integer :time
      t.integer :frames
      t.integer :fps

      t.timestamps
    end
  end
end
