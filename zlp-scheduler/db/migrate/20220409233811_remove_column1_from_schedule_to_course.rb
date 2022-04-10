class RemoveColumn1FromScheduleToCourse < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedule_to_courses, :day, :string
    add_column :schedule_to_courses, :weekday, :string
  end
end
