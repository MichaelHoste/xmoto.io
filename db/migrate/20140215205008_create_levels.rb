class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string  :file_name

      t.string  :name
      t.string  :description
      t.string  :author
      t.string  :date

      t.string  :level_identifier
      t.string  :level_pack
      t.string  :level_pack_num
      t.string  :rversion

      t.string  :preview

      t.timestamps
    end

    add_index :levels, :level_identifier, :unique => true

    LevelImportService.populate
  end
end
