class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :user,  :index => true
      t.references :level, :index => true
      t.integer    :time
      t.integer    :steps
      t.text       :replay

      t.timestamps
    end
  end
end
