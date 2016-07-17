class BlankAssumption < Assumption
  has_and_belongs_to_many :assumptions,
                          class_name: 'Assumption',
                          join_table: :required_assumptions,
                          foreign_key: :parent_id,
                          association_foreign_key: :child_id,
                          uniq: true
  validate :prevent_circular_dependencies

  def evaluate(analysis)
    !assumptions.map { |a| a.evaluate(analysis) }.uniq.include?(false)
  end

  def evaluate(analysis)
    @evaluate ||= begin
      result = true
      assumptions.where.not(type: QueryAssumption).each do |a|
        if (!a.evaluate(analysis))
          result = false
        end
      end
      result
    end
  end

  def get_queries(analysis)
    queries = []
    if (evaluate(analysis))
      # get sub queries
      assumptions.where.not(type: QueryAssumption).each do |a|
        queries << a.get_queries(analysis)
      end
      queries << assumptions.where(type: QueryAssumption)
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