require 'rails_helper'

RSpec.describe TestAssumption, type: :model do

  subject { TestAssumption.new }

  describe 'general TestAssumption' do
    it { expect(subject).to respond_to :required_by }
    it { expect(subject).not_to respond_to :assumptions }
  end

  describe 'assumptions and assumptions' do
    subject { FactoryGirl.create(:test_assumption) }
    it { expect(subject.required_by).to be_empty }
  end
end
