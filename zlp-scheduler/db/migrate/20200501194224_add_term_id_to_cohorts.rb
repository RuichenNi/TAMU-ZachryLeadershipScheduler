class AddTermIdToCohorts < ActiveRecord::Migration[5.0]
  def change
    add_column :cohorts, :term_id, :integer
  end
end
