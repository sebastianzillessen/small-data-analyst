require 'rails_helper'

RSpec.describe TestAssumption, type: :model do

  subject { TestAssumption.new }

  describe 'general TestAssumption' do
    it { expect(subject).not_to respond_to :attacking }
    it { expect(subject).to respond_to :attackers }
  end

  describe 'attackers and attacking' do
    subject { FactoryGirl.create(:test_assumption) }
    it { expect(subject.attackers).to be_empty }
  end
end
