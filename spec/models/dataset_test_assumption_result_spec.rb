require 'rails_helper'

RSpec.describe DatasetTestAssumptionResult, type: :model do
  subject { create(:dataset_test_assumption_result) }
  it { should respond_to(:dataset) }
  it { should respond_to(:test_assumption) }

  describe 'test_assumption reference' do
    let(:test_assumption) { create(:test_assumption) }
    let(:assumption) { create(:assumption) }
    it 'should be possible to add TestAssumptions' do
      subject.test_assumption = test_assumption
      expect(subject).to be_valid
    end

    it 'should be possible to add TestAssumptions' do
      expect {
        subject.test_assumption = assumption
      }.to raise_error
    end
  end
end
