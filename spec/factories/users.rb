FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "1234567"
    factory :statistician do
      role 'statistician'
    end
    factory :admin do
      role 'admin'
    end
    factory :clinician do
      role 'clinician'
    end
  end
end
