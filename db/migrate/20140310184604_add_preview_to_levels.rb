class AddPreviewToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :preview, :string
  end
end
