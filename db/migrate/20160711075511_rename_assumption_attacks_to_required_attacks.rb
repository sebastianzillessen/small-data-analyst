class RenameAssumptionAttacksToRequiredAttacks < ActiveRecord::Migration
  def change
    rename_table :assumption_attacks, :required_assumptions
    rename_column :required_assumptions, :attacker_id, :child_id
    rename_column :required_assumptions, :attacked_id, :parent_id
  end
end
