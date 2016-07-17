FactoryGirl.define do
  factory :preference_argument_without_preference, class: PreferenceArgument do
    assumption { create(:test_assumption) }
    model_orders { create_list(:model_order, 3) }
    factory :preference_argument do
      association :preference, :factory => :preference_without_preference_arguments
    end
  end
end
