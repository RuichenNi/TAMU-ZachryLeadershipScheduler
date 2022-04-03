class AddScheduleNameToStudentActions < ActiveRecord::Migration[5.2]
  def change
    add_column :student_actions, :schedule_name, :string
  end
end
