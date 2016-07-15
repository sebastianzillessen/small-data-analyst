require 'rails_helper'

RSpec.describe Dataset, type: :model do
  let!(:test_assumption) { create(:test_assumption) }
  let!(:dataset) { create(:dataset) }

  let(:dataset_result) {
    DatasetTestAssumptionResult.where(
        dataset: dataset, test_assumption: test_assumption).first
  }

  subject { dataset }

  it { should respond_to :user }
  it { should respond_to :columns }
  it { should respond_to :data_file }
  it { should respond_to :data }

  context 'parsing a file' do
    subject { Dataset.new(name: 'Test') }
    let(:data) { "test,columns\n1,2\n3,4" }
    let(:tempfile) {
      file = double(File, read: data)
    }
    it 'should parse the columns' do
      expect(subject).to receive(:parse_columns).once
      subject.data_file = tempfile
      subject.save

    end
    it 'should be valid' do
      subject.data_file = tempfile
      expect(subject).to be_valid
    end

    it 'should have the right columns' do
      subject.data_file = tempfile
      subject.valid?
      expect(subject.columns).to match_array ['test', 'columns']
    end

    it 'should have the right rows' do
      subject.data_file = tempfile
      subject.valid?
      expect(subject.rows).to match_array [["1", "2"], ["3", "4"]]
    end

    it 'should call update_dataset_test_assumption_results' do
      expect(subject).to receive(:update_dataset_test_assumptions_results).once
      subject.data = data
      subject.save
    end

    it 'should call update on the dataset_result' do
      expect_any_instance_of(DatasetTestAssumptionResult).to receive(:update).twice
      subject.data = data
      subject.save
    end


  end
  it 'should have cached results for all datasets in the system' do
    test_assumption = create(:test_assumption)
    subject = create(:dataset)
    expect(subject.dataset_test_assumption_results.map(&:test_assumption)).to include test_assumption
  end
end
