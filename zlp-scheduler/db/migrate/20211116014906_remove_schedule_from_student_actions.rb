class RemoveScheduleFromStudentActions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :student_actions, :schedule, foreign_key: true
  end
end
