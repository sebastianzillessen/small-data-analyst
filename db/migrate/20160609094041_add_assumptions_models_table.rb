class AddAssumptionsModelsTable < ActiveRecord::Migration
  def change
    create_table :assumptions_models do |t|
      t.references :model
      t.references :assumption
      t.timestamps null: false
    end
  end
end
