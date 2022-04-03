class AddUserIdToStudentActions < ActiveRecord::Migration[5.2]
  def change
    add_column :student_actions, :user_id, :int
  end
end
