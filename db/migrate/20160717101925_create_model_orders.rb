class CreateModelOrders < ActiveRecord::Migration
  def change
    create_table :model_orders do |t|
      t.references :preference_argument, index: true, foreign_key: true
      t.integer :index
      t.references :model, index: true, foreign_key: true

      t.timestamps null: false
    end

  end
end
