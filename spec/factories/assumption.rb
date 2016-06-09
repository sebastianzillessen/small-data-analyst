FactoryGirl.define do
  factory :assumption do
    name { Faker::Lorem.sentence(4) }
  end

  factory :critical_assumption, parent: :assumption do
    critical true
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
    r_code { "result <- true" }
  end

  factory :blank_assumption, class: BlankAssumption, parent: :critical_assumption


end