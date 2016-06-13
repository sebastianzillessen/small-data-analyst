class BlankAssumption < Assumption
  has_and_belongs_to_many :assumptions, class_name: 'Assumption', join_table: :assumption_attacks, foreign_key: :attacked_id, association_foreign_key: :attacker_id

  def evaluate_critical(analysis)
    assumptions.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
      if (a.evaluate_critical(analysis) == !!argument_inverted)
        return false
      end
    end
    return true
  end

  def get_critical_queries(analysis)
    queries = []
    if (evaluate_critical(analysis))
      # get sub critical queries
      assumptions.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
        queries << a.get_critical_queries(analysis)
      end
      queries << assumptions.select(&:critical).select { |a| a.class == QueryAssumption }
    end

    queries.flatten.uniq
  end
end