class RemoveDayFromScheduleToCourse < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedule_to_courses, :day, :string
  end
end
