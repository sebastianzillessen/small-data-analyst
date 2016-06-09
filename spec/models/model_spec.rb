require 'rails_helper'

RSpec.describe Model, type: :model do
  subject { create(:model) }
  it { should respond_to(:name, :description) }
  it { should respond_to(:analysises) }
  it { should respond_to(:research_questions) }
end
