class QueryAssumption < Assumption
  validates :question, presence: true

  def evaluate_critical(analysis)
    p = analysis.query_assumption_results.select { |qa| qa.query_assumption == self }

    if (p.present? && !p.result.nil?)
      return p.result
    end
  end

end