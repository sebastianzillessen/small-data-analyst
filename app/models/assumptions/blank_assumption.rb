class BlankAssumption < Assumption
  has_and_belongs_to_many :attacking, class_name: 'Assumption', join_table: :assumption_attacks, foreign_key: :attacker_id, association_foreign_key: :attacked_id
end