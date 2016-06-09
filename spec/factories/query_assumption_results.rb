FactoryGirl.define do
  factory :query_assumption_result do
    result true
    query_assumption
    analysis
  end
end
