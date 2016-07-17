class QueryAssumption < Assumption
  validates :question, presence: true

  def evaluate(analysis)
    analysis.query_assumption_results.where(query_assumption: self).first.try(:result)
  end

  def graph_representation(parent)
    ["#{parent.int_name} -> #{self.int_name}"]
  end
end