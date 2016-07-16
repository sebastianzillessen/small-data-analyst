class DeleteAllModelAssociations < ActiveRecord::Migration
  def up
    drop_table :analyses_models
  end

  def down
    create_table :analyses_models do |t|
      t.references :model
      t.references :analysis
    end
  end
end
