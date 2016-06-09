require 'rails_helper'

RSpec.describe ResearchQuestion, type: :model do
  subject { build(:research_question) }
  it { should respond_to :analysises }
  it { should respond_to :name }
  it { should respond_to :description }
  it { should validate_uniqueness_of :name }

end
