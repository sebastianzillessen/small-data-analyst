class AddStageToQueryAssumptionResult < ActiveRecord::Migration
  def change
    add_column :query_assumption_results, :stage, :integer
    add_column :analyses, :stage, :integer, default: 0
  end
end
