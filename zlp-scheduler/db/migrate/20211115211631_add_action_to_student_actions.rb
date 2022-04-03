class AddActionToStudentActions < ActiveRecord::Migration[5.2]
  def change
    add_column :student_actions, :action, :int
  end
end
