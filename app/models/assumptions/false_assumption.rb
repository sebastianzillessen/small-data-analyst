class FalseAssumption < Assumption
  def evaluate_critical
    puts "#{name} is a false assumption and returns false"
    false
  end
end