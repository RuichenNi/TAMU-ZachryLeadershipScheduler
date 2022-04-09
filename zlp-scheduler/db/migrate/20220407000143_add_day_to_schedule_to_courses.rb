class AddDayToScheduleToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :schedule_to_courses, :day, :integer, default:1
  end
end
