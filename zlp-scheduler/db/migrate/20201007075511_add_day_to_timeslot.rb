class AddDayToTimeslot < ActiveRecord::Migration[5.0]
  def change
    add_column :time_slots, :day, :string
  end
end
