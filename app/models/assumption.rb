class Assumption < ActiveRecord::Base
  #TODO: Make Assumption abstract
  #self.abstract_class = true

  has_and_belongs_to_many :attackers, class_name: 'Assumption', join_table: :assumption_attacks, foreign_key: :attacked_id, association_foreign_key: :attacker_id
  has_and_belongs_to_many :models

  validates :name, presence: true, uniqueness: true


  def evaluate_critical
    evaluate_attackers_critical
  end

  def get_critical_queries
    queries = []
    if (evaluate_attackers_critical)
      # get sub critical queries
      attackers.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
        queries << a.get_critical_queries
      end
      queries << attackers.select(&:critical).select { |a| a.class == QueryAssumption }
    end

    queries.flatten.uniq
  end

  protected

  def evaluate_attackers_critical
    attackers.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
      if (a.evaluate_critical == !!argument_inverted)
        return false
      end
    end
    return true
  end


end
