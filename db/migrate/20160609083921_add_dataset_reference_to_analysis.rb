class AddDatasetReferenceToAnalysis < ActiveRecord::Migration
  def change
    add_reference :analyses, :dataset, index: true, foreign_key: true
  end
end
