class AddCohortIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cohort_id, :integer
  end
end
