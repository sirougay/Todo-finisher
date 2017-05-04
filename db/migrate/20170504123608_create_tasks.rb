class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.text :content
      t.integer :spent_time
      t.time :notification_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
