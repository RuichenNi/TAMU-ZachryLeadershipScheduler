class RemoveUserFromStudentActions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :student_actions, :user, foreign_key: true
  end
end
