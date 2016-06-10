class AddIgnoreAttributeToQueryAssumptionResult < ActiveRecord::Migration
  def change
    add_column :query_assumption_results, :ignore, :boolean, default: false
  end
end
