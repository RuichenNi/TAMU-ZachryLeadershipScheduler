class AddColumnsToScheduleToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :schedule_to_courses, :day, :string
    add_column :schedule_to_courses, :start_time, :string
    add_column :schedule_to_courses, :end_time,:string
  end
end
