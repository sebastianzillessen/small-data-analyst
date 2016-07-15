class DatasetTestAssumptionResult < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :test_assumption, class_name: 'TestAssumption', foreign_key: :assumption_id

  validates :dataset, presence: true, uniqueness: {scope: :test_assumption}
  validates :test_assumption, presence: true, uniqueness: {scope: :dataset}
  validates :result, :inclusion => {:in => [true, false, nil]}

  after_create :update, if: -> { result.nil? }


  def update
    if dataset && test_assumption
      self.result = test_assumption.eval_internal(dataset)
      save
    end
    self.result
  end
  handle_asynchronously :update

end
