FactoryGirl.define do
  factory :dataset do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(5) }
    data IO.read(Rails.root.join("db/data/ovarian.csv"))
  end
end
