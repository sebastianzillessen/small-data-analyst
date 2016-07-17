class AddRejectedToPossibleModel < ActiveRecord::Migration
  def change
    add_column :possible_models, :rejected, :boolean, default: false
  end
end
