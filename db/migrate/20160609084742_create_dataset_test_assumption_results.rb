class CreateDatasetTestAssumptionResults < ActiveRecord::Migration
  def change
    create_table :dataset_test_assumption_results do |t|
      t.references :dataset, index: true, foreign_key: true
      t.references :assumption, index: true, foreign_key: true
      t.boolean :result

      t.timestamps null: false
    end
  end
end
