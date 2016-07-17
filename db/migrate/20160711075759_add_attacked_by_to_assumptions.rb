class AddAttackedByToAssumptions < ActiveRecord::Migration
  def change
    create_table :assumption_attacks do |t|
      t.integer :child_id
      t.integer :parent_id
    end
  end
end
