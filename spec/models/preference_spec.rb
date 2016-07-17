require 'rails_helper'

RSpec.describe Preference, type: :model do
  subject{create(:preference)}

  it{is_expected.to be_valid}
  it{is_expected.to respond_to(:research_question)}
  it{is_expected.to respond_to(:stage)}
  it{is_expected.to respond_to(:user)}
  it{is_expected.to respond_to(:name)}
  it{is_expected.to respond_to(:int_name)}
  it{is_expected.to respond_to(:preference_arguments)}
  it{is_expected.to respond_to(:global)}
  it 'should be able to delete' do
    expect(subject.destroy).to be_truthy
  end
end
