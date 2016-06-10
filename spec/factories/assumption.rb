FactoryGirl.define do
  factory :assumption do
    name { Faker::Lorem.sentence(4) }
    factory :query_assumption, class: QueryAssumption do
      question "This is a default question"
    end
    factory :blank_assumption, class: BlankAssumption
  end

  factory :critical_assumption, parent: :assumption do
    critical true
    factory :critical_blank_assumption, class: BlankAssumption
    factory :critical_query_assumption, class: QueryAssumption do
      question "This is a default question"
    end
  end
  #    :name => "MyString",
  #    :description => "MyText",
  #    :critical => false,
  #    :type => "",
  #    :required_dataset_fields => "MyText",
  #    :fail_on_missing => false,
  #    :r_code => "MyText",
  #    :question => "MyText",
  #    :argument_inverted => false

  factory :test_assumption, class: TestAssumption, parent: :assumption do
    description { Faker::Lorem.sentences(4) }
    fail_on_missing false
    r_code { "result <- TRUE" }

    factory :critical_test_assumption do
      critical true
    end
  end


end