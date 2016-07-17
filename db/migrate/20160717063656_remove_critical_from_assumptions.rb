class RemoveCriticalFromAssumptions < ActiveRecord::Migration
  def change
    remove_column :assumptions, :critical
  end
end
