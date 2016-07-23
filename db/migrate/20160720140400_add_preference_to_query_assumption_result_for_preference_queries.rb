class AddPreferenceToQueryAssumptionResultForPreferenceQueries < ActiveRecord::Migration
  def change
    add_reference :query_assumption_results, :preference
    add_column :query_assumption_results, :type, :string
  end
end
