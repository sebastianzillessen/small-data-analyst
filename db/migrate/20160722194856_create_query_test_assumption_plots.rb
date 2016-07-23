class CreateQueryTestAssumptionPlots < ActiveRecord::Migration
  def change
    create_table :query_test_assumption_plots do |t|
      t.references :query_test_assumption
      t.references :plot
      t.references :dataset

      t.timestamps null: false
    end
  end
end
