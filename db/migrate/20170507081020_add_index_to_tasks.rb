class AddIndexToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :index, :integer
  end
end
