FactoryGirl.define do
  factory :assumption do
    name { Faker::Lorem.sentence(4) }
    factory :query_assumption, class: QueryAssumption do
      question "This is a default question"
    end
    factory :blank_assumption, class: BlankAssumption
  end

  #    :name => "MyString",
  #    :description => "MyText",
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


  end


end