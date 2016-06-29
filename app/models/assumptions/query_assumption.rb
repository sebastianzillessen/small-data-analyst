class QueryAssumption < Assumption
  validates :question, presence: true

  def evaluate(analysis)
    evaluate_critical(analysis)
  end

  def evaluate_critical(analysis)
    analysis.query_assumption_results.select { |qa| qa.query_assumption == self }.first.try(:result)
  end

end