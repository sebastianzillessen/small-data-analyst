RSpec.configure do |c|
  if (ENV['TRAVIS'])
    c.filter_run_excluding :travis => false
  end
end