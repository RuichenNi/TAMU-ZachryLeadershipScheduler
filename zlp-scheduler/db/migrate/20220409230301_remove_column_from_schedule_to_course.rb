class RemoveColumnFromScheduleToCourse < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedule_to_courses, :day, :integer
  end
end
