FactoryGirl.define do
  factory :plot do
    filename "foo/test.png"
    object { create(:model) }
  end
end
