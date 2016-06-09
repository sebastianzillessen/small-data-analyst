require 'rails_helper'

RSpec.describe QueryAssumption, type: :model do

  subject { QueryAssumption.new }

  describe 'general QueryAssumption' do
    it { expect(subject).to respond_to :attackers}
    it { expect(subject).not_to respond_to :attacking}
  end

  describe 'attackers and attacking' do
    subject { FactoryGirl.create(:query_assumption) }
    it { expect(subject.attackers).to be_empty }
  end
end
