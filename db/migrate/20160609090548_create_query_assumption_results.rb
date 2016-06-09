class CreateQueryAssumptionResults < ActiveRecord::Migration
  def change
    create_table :query_assumption_results do |t|
      t.boolean :result
      t.references :dataset, index: true, foreign_key: true
      t.references :assumption, index: true, foreign_key: true
      t.references :analysis, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
