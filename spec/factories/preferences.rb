FactoryGirl.define do

  factory :preference_without_preference_arguments, class: Preference do
    name "MyString"
    stage 1
    user
    factory :preference do
      preference_arguments { create_list(:preference_argument_without_preference, 2) }
    end
  end
end
