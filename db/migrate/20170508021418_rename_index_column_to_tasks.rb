class RenameIndexColumnToTasks < ActiveRecord::Migration[5.0]
  def change
  	rename_column :tasks, :index, :position
  end
end
