FactoryGirl.define do
  factory :preference_argument_without_preference, class: PreferenceArgument do
    assumption { create(:test_assumption) }
    after(:build) { |pa|
      pa.model_orders = build_list(:model_order_without_preference_argument, 3)
    }
    factory :preference_argument do
      association :preference, factory: :preference_without_preference_arguments, strategy: :build
    end
  end
end
