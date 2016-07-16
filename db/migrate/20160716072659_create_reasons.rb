class CreateReasons < ActiveRecord::Migration
  def change
    create_table :reasons do |t|
      t.references :argument, polymorphic: true, index: true
      t.references :possible_model, index: true
      t.integer :stage
      t.timestamps null: false
    end
  end
end
