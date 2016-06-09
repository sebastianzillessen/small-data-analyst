class AddDatasetReferenceToAnalysis < ActiveRecord::Migration
  def change
    add_reference :analyses, :dataset, index: true
  end
end
