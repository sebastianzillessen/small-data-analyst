class CreateQueryAssumptionResults < ActiveRecord::Migration
  def change
    create_table :query_assumption_results do |t|
      t.boolean :result
      t.references :assumption, index: true
      t.references :analysis, index: true

      t.timestamps null: false
    end
  end
end
