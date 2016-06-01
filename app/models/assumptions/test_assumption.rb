class TestAssumption < Assumption
  validates :attacking, length: {maximum: 0}
  validates :r_code, presence: true

  def evaluate_critical
    self.r_code
  end
end