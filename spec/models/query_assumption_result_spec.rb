require 'rails_helper'

RSpec.describe QueryAssumptionResult, type: :model do
  subject { build(:query_assumption_result) }

  it { should respond_to(:dataset) }
  it { should respond_to(:query_assumption) }
  it { should respond_to(:analysis) }

  describe 'validation' do
    it 'should allow nil for result' do
      subject.result = nil
      expect(subject).to be_valid
    end
  end

  describe 'query_assumption reference' do
    let(:query_assumption) { create(:query_assumption) }
    let(:assumption) { create(:assumption) }
    it 'should be possible to add QueryAssumptions' do
      subject.query_assumption = query_assumption
      expect(subject).to be_valid
    end

    it 'should not be possible to add Assumptions' do
      expect {
        subject.query_assumption = assumption
      }.to raise_error ActiveRecord::AssociationTypeMismatch
    end
  end

  describe 'only one per analysis and assumption' do
    let(:element) { create(:query_assumption_result) }
    it 'should be invalid to have a second query_assumption' do
      subject.query_assumption = element.query_assumption
      subject.analysis = element.analysis
      expect(subject).not_to be_valid
    end

  end


end
