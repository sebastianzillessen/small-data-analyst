class CreatePossibleModels < ActiveRecord::Migration
  def change
    create_table :possible_models do |t|
      t.references :analysis
      t.references :model
      t.timestamps null: false
    end
  end
end
