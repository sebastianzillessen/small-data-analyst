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
    subject { create(:analysis, :with_models) }


    it { expect(subject.research_question.models.length).to eq 3 }

    it { should respond_to :start }


    it 'should create new QueryAssumptionResults with nil value' do
      expect {
        subject.start
      }.to change {
        subject.query_assumption_results
      }
    end

  end
end
