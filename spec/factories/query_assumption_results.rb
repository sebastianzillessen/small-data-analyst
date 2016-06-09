FactoryGirl.define do
  factory :query_assumption_result do
    result nil
    dataset
    query_assumption
    analysis
  end
end
