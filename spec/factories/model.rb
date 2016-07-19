FactoryGirl.define do

  factory :model do |f|
    name { Faker::Lorem.sentence(4) }
    description { Faker::Lorem.sentence(4) }
    research_questions { create_list(:research_question, 1) }

    factory :model_without_research_question do |f|
      research_questions {}
    end
  end
end
