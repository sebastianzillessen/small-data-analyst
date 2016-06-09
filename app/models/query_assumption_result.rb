class QueryAssumptionResult < ActiveRecord::Base
  belongs_to :query_assumption, class_name: 'QueryAssumption', foreign_key: :assumption_id
  belongs_to :analysis
  has_one :dataset, through: :analsyis
end
