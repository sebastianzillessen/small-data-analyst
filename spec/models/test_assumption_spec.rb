require 'rails_helper'

RSpec.describe TestAssumption, type: :model do

  subject { create(:test_assumption) }
  let!(:dataset) { create(:dataset) }
  it { is_expected.to be_valid }

  describe 'check if the columns in the dataset are present' do
    it 'should succeed' do
      expect(subject.send(:check_dataset_mets_column_names, dataset)).to be_truthy
    end
    it 'should not succeed if the columns are not present' do
      subject.required_dataset_fields << 'foo'
      expect(subject.send(:check_dataset_mets_column_names, dataset)).to be_falsey
    end
    it 'should not succeed if there are columns in both but the assumption requires one more' do
      subject.required_dataset_fields << 'foo'
      subject.required_dataset_fields << 'bar'
      dataset.columns << 'foo'
      expect(subject.send(:check_dataset_mets_column_names, dataset)).to be_falsey
    end

    it 'should succeed if there are columns in both' do
      subject.required_dataset_fields << 'foo'
      dataset.columns << 'foo'
      dataset.columns << 'bar'
      expect(subject.send(:check_dataset_mets_column_names, dataset)).to be_truthy
    end

  end
  let(:dataset_result) { DatasetTestAssumptionResult.where(dataset: dataset, test_assumption: subject).first }

  it 'should trigger update on dataset_test_assumption_result' do
    expect(subject).to be_valid
    subject.send(:generate_dataset_test_assumptions_results)
    expect_any_instance_of(DatasetTestAssumptionResult).to receive(:update).once
    subject.r_code = "Something"

    subject.save
  end


  describe 'check required dataset fields' do
    subject { create(:test_assumption) }
    it 'should assign empty array' do
      skip("write specs")
    end
  end


end
