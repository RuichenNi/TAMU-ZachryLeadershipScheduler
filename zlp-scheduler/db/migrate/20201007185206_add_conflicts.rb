class AddConflicts < ActiveRecord::Migration[5.0]
  def change
    create_table :conflicts do |t|
      t.references :user, null: true
      t.integer :cost
      t.references :course, null: true
      t.references :schedule
      t.references :time_slot
    end
    
    add_reference :time_slots, :conflicts
  end
end
