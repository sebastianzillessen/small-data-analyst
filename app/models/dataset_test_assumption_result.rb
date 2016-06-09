class DatasetTestAssumptionResult < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :test_assumption, class_name: 'TestAssumption', foreign_key: :assumption_id
end
