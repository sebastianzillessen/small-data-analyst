RSpec::Matchers.define :match_hash do |expected|
  match do |actual|
    matches_hash?(expected, actual)
  end
end

def matches_hash?(expected, actual)
  matches_array?(expected.keys, actual.keys) &&
      actual.all? { |k, xs| matches_array?(expected[k], xs) }
end

def matches_array?(expected, actual)
  return expected == actual unless expected.is_a?(Array) && actual.is_a?(Array)
  expect(expected).to match_array(actual)
end