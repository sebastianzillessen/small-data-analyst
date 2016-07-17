class CreatePlots < ActiveRecord::Migration
  def change
    create_table :plots do |t|
      t.string :filename
      t.references :object, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
