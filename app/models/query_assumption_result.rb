class QueryAssumptionResult < ActiveRecord::Base
  belongs_to :query_assumption, class_name: 'QueryAssumption', foreign_key: :assumption_id
  belongs_to :analysis
  has_one :dataset, through: :analsyis
  after_update :trigger_update_on_analysis, if: :result_changed?

  validates :assumption_id, uniqueness: {scope: :analysis_id}
  validates :result, inclusion: {in: [true, false, nil]}

  private

  def trigger_update_on_analysis
    self.analysis.updated_query_assumption_result(self)
  end
end
