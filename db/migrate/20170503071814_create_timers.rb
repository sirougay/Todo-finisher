class CreateTimers < ActiveRecord::Migration[5.0]
  def change
    create_table :timers do |t|
      t.integer :pomodoro
      t.integer :short_rest
      t.integer :long_rest
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
