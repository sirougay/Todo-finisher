class AddDiaryIdToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :diary_id, :integer
  end
end
