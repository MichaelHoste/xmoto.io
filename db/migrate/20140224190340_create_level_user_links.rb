class CreateLevelUserLinks < ActiveRecord::Migration
  def change
    create_table :level_user_links do |t|
      t.references :user,  :index => true
      t.references :level, :index => true
      t.integer    :time
      t.integer    :steps
      t.integer    :fps

      t.timestamps
    end
  end
end
