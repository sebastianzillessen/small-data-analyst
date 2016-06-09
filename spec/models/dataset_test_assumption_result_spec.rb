require 'rails_helper'

RSpec.describe DatasetTestAssumptionResult, type: :model do
  subject { create(:dataset_test_assumption_result) }
  it { should respond_to(:dataset) }
  it { should respond_to(:test_assumption) }

  describe 'validation' do
    it 'should not allow nil for result' do
      subject.result = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'test_assumption reference' do
    let(:test_assumption) { create(:test_assumption) }
    let(:assumption) { create(:assumption) }
    it 'should be possible to add TestAssumptions' do
      subject.test_assumption = test_assumption
      expect(subject).to be_valid
    end

    it 'should not be possible to add Assumptions' do
      expect {
        subject.test_assumption = assumption
      }.to raise_error ActiveRecord::AssociationTypeMismatch
    end
  end
end
