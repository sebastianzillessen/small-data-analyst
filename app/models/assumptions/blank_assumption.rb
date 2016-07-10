class BlankAssumption < Assumption
  has_and_belongs_to_many :assumptions,
                          class_name: 'Assumption',
                          join_table: :assumption_attacks,
                          foreign_key: :attacked_id,
                          association_foreign_key: :attacker_id,
                          uniq: true
  validate :prevent_circular_dependencies

  def evaluate(analysis)
    !assumptions.map { |a| a.evaluate(analysis) }.uniq.include?(false)
  end

  def evaluate_critical(analysis)
    @evaluate_critical ||= begin
      result = true
      assumptions.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
        if (!a.evaluate_critical(analysis))
          result = false
        end
      end
      result
    end
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

  private

  def prevent_circular_dependencies
    if (get_all_parents.include?(self))
      errors.add(:assumptions, "There is a circular dependency between this BlankAssumption and its required-by and/or required assumptions which will cause problems.")
    end
  end
end