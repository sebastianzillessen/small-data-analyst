FactoryGirl.define do
  factory :dataset do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(5) }
  end
end
