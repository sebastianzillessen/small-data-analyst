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
  factory :admin_user, class: Admin::User do
    email { Faker::Internet.email }
    password "1234567"
    factory :admin_statistician do
      role 'statistician'
    end
    factory :admin_admin do
      role 'admin'
    end
    factory :admin_clinician do
      role 'clinician'
    end
  end
end
