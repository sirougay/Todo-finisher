class AddPomodoroTimeToDiarys < ActiveRecord::Migration[5.0]
  def change
    add_column :diaries, :pomodoro_time, :integer
  end
end
