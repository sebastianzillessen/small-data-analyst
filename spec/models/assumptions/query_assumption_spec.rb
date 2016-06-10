require 'rails_helper'

RSpec.describe QueryAssumption, type: :model do

  subject { QueryAssumption.new }

  describe 'general QueryAssumption' do
    it { expect(subject).not_to respond_to :assumptions }
    it { expect(subject).to respond_to :required_by }
  end

  describe 'assumptions and assumptions' do
    subject { FactoryGirl.create(:query_assumption) }
    it { expect(subject.required_by).to be_empty }
  end
end
