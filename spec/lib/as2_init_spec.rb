require 'rails_helper'

RSpec.describe As2Init, type: :class do
  let!(:m1) { create(:model, name: "m1") }
  let!(:m2) { create(:model, name: "m2") }
  let!(:m3) { create(:model, name: "m3") }
  let!(:research_question) { create(:research_question, models: [m1, m2, m3]) }
  let(:analysis) { create(:analysis, research_question: research_question) }

  subject { As2Init.new(analysis) }

  it 'should have 3 possible models' do
    expect(analysis.remaining_models.size).to eq 3
  end

  it 'should have 3 possible models' do
    expect(analysis.remaining_models).to match_array [m1, m2, m3]
  end

  it 'should return all model rules as contradictions' do
    expect(subject.send(:model_rules, 1).length).to eq 9
  end

  it 'should have 2 subclasses' do
    expect(Preferences::AS2.subclasses.length).to eq 2
  end

end
