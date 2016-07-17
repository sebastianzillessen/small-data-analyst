class AddHabtmToModelOrder < ActiveRecord::Migration
  def change
    create_table :model_orders_models, index: false do |t|
      t.references :model, index: true, foreign_key: true
      t.references :model_order, index: true, foreign_key: true
    end

    remove_reference :model_orders, :model
  end
end
