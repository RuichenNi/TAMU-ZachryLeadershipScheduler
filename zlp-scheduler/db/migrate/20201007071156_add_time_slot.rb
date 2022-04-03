class AddTimeSlot < ActiveRecord::Migration[5.0]
  def change
    create_table :time_slots do |t|
      t.datetime :time
      t.integer :cost
      t.boolean :was_conflict
      t.references :cohort
    end
    add_reference :cohorts, :time_slots
  end
end
