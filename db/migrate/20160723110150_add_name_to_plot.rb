class AddNameToPlot < ActiveRecord::Migration
  def change
    add_column :plots, :name, :string
  end
end
