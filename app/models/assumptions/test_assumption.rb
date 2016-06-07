class TestAssumption < Assumption
  validates :attacking, length: {maximum: 0}
  validates :r_code, presence: true
  serialize :required_dataset_fields, Array

  def evaluate_critical
    self.r_code
  end
end