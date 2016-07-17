require 'rails_helper'

RSpec.describe Analysis, type: :model do
  subject { build :analysis }
  it { should respond_to(:private) }
  it { should respond_to(:in_progress) }
  it { expect(:in_progress).to be_truthy }
  it { should respond_to :dataset }
  it { should respond_to :research_question }
  it { should respond_to :possible_models }
  it { should respond_to :query_assumption_results }
  it { should validate_presence_of :research_question }
  it { should validate_presence_of :dataset }


  describe '#start' do
    subject { create(:analysis_survival) }


    it { expect(subject.research_question.models.length).to eq 3 }
    it { should respond_to :start }

    it 'should trigger start' do
      expect_any_instance_of(Analysis).to receive(:start).once
      create(:analysis)
    end

    it 'should create new QueryAssumptionResults' do
      expect(subject.query_assumption_results).not_to be_empty
    end

    it 'should create only one QueryAssumptionResults' do
      expect(subject.query_assumption_results.length).to eq(1)
    end

    it 'should create a QueryAssumptionResults for a1' do
      expect(subject.query_assumption_results.first.query_assumption.name).to eq('a1')
    end

    it 'should assign 2 possible models for now' do
      expect(subject.possible_models.length).to eq(2)
      subject.remaining_models.map(&:name).each do |name|
        expect(name.include?("Kaplan Meier") || name.include?("Weibull")).to be_truthy
      end
    end

  end
end
