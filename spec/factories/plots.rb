FactoryGirl.define do
  factory :plot do
    filename "#{Plot::BASE_URL}/foo/test.png"
    object { create(:model) }
  end
end
