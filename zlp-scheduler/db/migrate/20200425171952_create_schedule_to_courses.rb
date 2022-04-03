class CreateScheduleToCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :schedule_to_courses do |t|
      t.references :schedule, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
