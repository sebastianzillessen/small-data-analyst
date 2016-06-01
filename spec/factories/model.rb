FactoryGirl.define do
  factory :model do |f|
    name {Faker::Lorem.sentence(4)}
    description {Faker::Lorem.sentence(4)}
    research_questions { create_list(:research_question, 1) }

  end
end
