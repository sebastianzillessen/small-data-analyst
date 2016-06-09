require "rinruby"

class TestAssumption < Assumption
  validates :r_code, presence: true
  serialize :required_dataset_fields, Array
=begin
  R = RinRuby.new
  n = 10
  beta_0 = 1
  beta_1 = 0.25
  alpha = 0.05
  seed = 23423
  R.assign('x', (1..n).entries)
  R.eval <<EOF
    set.seed(#{seed})
    y <- #{beta_0} + #{beta_1}*x + rnorm(#{n})
    fit <- lm( y ~ x )
    est <- round(coef(fit),3)
    pvalue <- summary(fit)$coefficients[2,4]
  EOF
  puts "E(y|x) ~= #{R.pull('est')[0]} + #{R.pull('est')[1]} * x"
  if R.pull('pvalue') < alpha
    puts "Reject the null hypothesis and conclude that x and y are related."
  else
    puts "There is insufficient evidence to conclude that x and y are related."
  end
=end

  def evaluate_critical
    r = RinRuby.new
    r.eval r_code
    result = r.pull('result')
    r.quit
    return result
  end
end