FactoryGirl.define do
  factory :research_question do
    name { Faker::Lorem.sentence(4) }
    description { Faker::Lorem.sentence(4) }
  end

  factory :research_question_with_model, parent: :research_question do
    models { FactoryGirl.create_list(:model, 1) }
  end
end
