require 'rails_helper'

RSpec.describe ResearchQuestion, type: :model do
  subject { build(:research_question) }
  it { should respond_to :analyses}
  it { should respond_to :name }
  it { should respond_to :description }
  it { should respond_to :preferences }
  it { should validate_uniqueness_of :name }
  it 'should be able to delete' do
    expect(subject.destroy).to be_truthy
  end
end
