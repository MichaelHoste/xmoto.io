class CreateUserUserLinks < ActiveRecord::Migration
  def change
    create_table :user_user_links do |t|
      t.references :user,   :limit => 8, :index => true
      t.references :friend, :limit => 8, :index => true

      t.timestamps
    end
  end
end
