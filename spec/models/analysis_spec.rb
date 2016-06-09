require 'rails_helper'

RSpec.describe Analysis, type: :model do
  subject { build :analysis }
  it { should respond_to(:private) }
  it { should respond_to(:in_progress) }
  it { expect(:in_progress).to be_truthy }
  it { should respond_to :dataset }
  it { should respond_to :research_question }
  it { should respond_to :possible_models }
  it { should validate_presence_of :research_question }
  it { should validate_presence_of :dataset }
end
