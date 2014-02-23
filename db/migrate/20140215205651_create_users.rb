class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.string  :picture
      t.string  :gender
      t.string  :locale
      t.string  :provider

      t.integer  :f_id,         :limit => 8
      t.string   :f_token
      t.string   :f_first_name
      t.string   :f_middle_name
      t.string   :f_last_name
      t.string   :f_username
      t.string   :f_location
      t.string   :f_location_id
      t.string   :f_link
      t.integer  :f_timezone
      t.datetime :f_updated_time
      t.boolean  :f_verified
      t.boolean  :f_expires
      t.datetime :f_expires_at

      t.datetime :registered_at
      t.integer  :friends_count,    :default => 0, :null => false
      t.integer  :total_won_levels, :default => 0, :null => false
      t.datetime :friends_updated_at

      t.timestamps
    end

    add_index :users, :f_id, :unique => true
  end
end

