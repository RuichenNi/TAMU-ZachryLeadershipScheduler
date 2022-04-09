class AddColumnToScheduleToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :schedule_to_courses, :day, :string
  end
end
