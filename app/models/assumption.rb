class Assumption < ActiveRecord::Base
  has_and_belongs_to_many :attackers, class_name: 'Assumption', join_table: :assumption_attacks, foreign_key: :attacked_id, association_foreign_key: :attacker_id

  validates :name, presence: true, uniqueness: true



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
