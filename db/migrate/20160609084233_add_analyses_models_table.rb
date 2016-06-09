class AddAnalysesModelsTable < ActiveRecord::Migration
  def change
    create_table :analyses_models do |t|
      t.references :model
      t.references :analysis
    end
  end
end
