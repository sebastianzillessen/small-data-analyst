require 'rails_helper'

RSpec.describe ModelOrder, type: :model do
  subject { create(:model_order) }
  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:preference_argument) }
  it { is_expected.to respond_to(:models) }
  it { is_expected.to respond_to(:index) }
  it 'should be able to delete' do
    expect(subject.destroy).to be_truthy
  end


end
