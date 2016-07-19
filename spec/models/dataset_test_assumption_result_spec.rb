require 'rails_helper'

RSpec.describe DatasetTestAssumptionResult, type: :model do
  let!(:dataset) { create(:dataset) }
  let!(:test_assumption) { create(:test_assumption) }

  subject { DatasetTestAssumptionResult.create(dataset: dataset, test_assumption: test_assumption) }

  it { should respond_to(:dataset) }
  it { should respond_to(:test_assumption) }

  describe 'validation' do
    it 'should allow nil for result' do
      subject.result = nil
      expect(subject).to be_valid
    end
  end

  describe 'test_assumption reference' do
    let(:assumption) { create(:assumption) }
    subject { DatasetTestAssumptionResult.create(dataset: dataset, test_assumption: test_assumption) }
    it 'should be possible to add TestAssumptions' do
      subject.test_assumption = test_assumption
      expect(subject).to be_valid
    end

    it 'should not be possible to add Assumptions' do
      expect {
        subject.test_assumption = assumption
      }.to raise_error ActiveRecord::AssociationTypeMismatch
    end

    describe 'with test assumption' do

      it 'should return the test assumption' do
        expect(subject.test_assumption).to eq test_assumption
      end


      it 'should trigger update method on change of dataset' do
        expect_any_instance_of(DatasetTestAssumptionResult).to receive(:update).once
        subject.dataset.data= "test,data,row\n1,2,3\n4,5,6"
        subject.dataset.save
      end

      describe '#update' do
        it 'should trigger evaluate on test_assumpiton' do
          expect(subject.test_assumption).to receive(:eval_internal).once.with(subject.dataset).and_return(true)
          expect(subject.test_assumption).not_to receive(:evaluate)
          expect(subject.update).to be_truthy
          expect(subject.result).to be_truthy
        end
      end

    end
  end
end
