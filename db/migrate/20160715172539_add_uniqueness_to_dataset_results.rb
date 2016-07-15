class AddUniquenessToDatasetResults < ActiveRecord::Migration
  def change
    add_index :dataset_test_assumption_results, [:dataset_id, :assumption_id], :unique => true, name: 'uniq_dataset_assumption'
  end
end
