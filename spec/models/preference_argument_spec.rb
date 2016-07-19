require 'rails_helper'

RSpec.describe PreferenceArgument, type: :model do
  subject{create(:preference_argument)}
  it{is_expected.to be_valid}
  it{is_expected.to respond_to :model_orders}
  it{is_expected.to respond_to :models}
  it{is_expected.to respond_to :models_grouped}
  it{is_expected.to respond_to :assumption}
  it{is_expected.to respond_to :preference}
  it 'should be able to delete' do
    expect(subject.destroy).to be_truthy
  end
end
