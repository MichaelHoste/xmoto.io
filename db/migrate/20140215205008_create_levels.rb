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

      t.timestamps
    end

    LevelImportService.populate
  end
end
