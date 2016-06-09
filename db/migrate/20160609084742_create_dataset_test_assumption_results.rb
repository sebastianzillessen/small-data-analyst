class CreateDatasetTestAssumptionResults < ActiveRecord::Migration
  def change
    create_table :dataset_test_assumption_results do |t|
      t.references :dataset, index: true
      t.references :assumption, index: true
      t.boolean :result

      t.timestamps null: false
    end
  end
end
