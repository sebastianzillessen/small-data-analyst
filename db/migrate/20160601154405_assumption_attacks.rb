class AssumptionAttacks < ActiveRecord::Migration
  def change
    create_table :assumption_attacks do |t|
      t.integer :attacker_id
      t.integer :attacked_id
    end
  end
end
