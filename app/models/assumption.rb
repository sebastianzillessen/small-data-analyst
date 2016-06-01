class Assumption < ActiveRecord::Base
  has_and_belongs_to_many :attackers, class_name: 'Assumption', join_table: :assumption_attacks, foreign_key: :attacked_id, association_foreign_key: :attacker_id
  has_and_belongs_to_many :attacking, class_name: 'Assumption', join_table: :assumption_attacks, foreign_key: :attacker_id, association_foreign_key: :attacked_id

  validates :name, presence: true, uniqueness: true
  serialize :required_dataset_fields, Array


  def evaluate_critical
    evaluate_attackers_critical
  end

  protected

  def evaluate_attackers_critical
    attackers.where(critical: true).each do |a|
      if (a.evaluate_critical == !!argument_inverted )
        return false
      end
    end
    return true
  end


end
