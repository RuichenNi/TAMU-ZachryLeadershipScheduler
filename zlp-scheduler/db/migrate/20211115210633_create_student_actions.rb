class CreateStudentActions < ActiveRecord::Migration[5.2]
  def change
    create_table :student_actions do |t|
      t.references :schedule, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
