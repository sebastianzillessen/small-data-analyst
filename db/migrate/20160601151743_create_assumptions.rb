class CreateAssumptions < ActiveRecord::Migration
  def change
    create_table :assumptions do |t|
      t.string :name
      t.text :description
      t.boolean :critical
      t.string :type
      t.text :required_dataset_fields
      t.boolean :fail_on_missing
      t.text :r_code
      t.text :question
      t.boolean :argument_inverted, default: false

      t.timestamps null: false
    end
  end
end
