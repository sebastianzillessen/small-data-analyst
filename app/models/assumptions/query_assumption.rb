class QueryAssumption < Assumption
  validates :question, presence: true
  belongs_to :analysis

  def evaluate(analysis)
    analysis.query_assumption_results.where(query_assumption: self).first.try(:result)
  end
end