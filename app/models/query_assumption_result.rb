class QueryAssumptionResult < ActiveRecord::Base
  belongs_to :query_assumption, class_name: 'QueryAssumption', foreign_key: :assumption_id
  belongs_to :analysis
  has_one :dataset, through: :analsyis
  after_update :trigger_update_on_analysis, if: :result_changed?

  validates :assumption_id, uniqueness: {scope: :analysis_id}

  private

  def trigger_update_on_analysis

  end
end
