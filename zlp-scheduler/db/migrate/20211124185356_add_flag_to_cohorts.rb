class AddFlagToCohorts < ActiveRecord::Migration[5.2]
  def change
    add_column :cohorts, :flag, :integer, default: 0
  end
end
