FactoryGirl.define do
  factory :model_order do
    sequence(:index) { |n| n }
    models { create_list(:model, 1) }
    association :preference_argument, strategy: :build, factory: :preference_argument

    factory :model_order_without_preference_argument do
      preference_argument {}
    end
  end

end
