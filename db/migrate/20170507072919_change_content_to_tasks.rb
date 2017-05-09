class ChangeContentToTasks < ActiveRecord::Migration[5.0]
   def up
    change_column :tasks, :content, :string
  end

  def down
    change_column :tasks, :content, :text
  end
end
