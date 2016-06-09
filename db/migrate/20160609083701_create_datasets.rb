class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :name
      t.text :description
      t.text :data
      t.text :columns

      t.timestamps null: false
    end
  end
end
