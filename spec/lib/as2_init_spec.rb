require 'rails_helper'

RSpec.describe As2Init, type: :class do
  let(:m1) { create(:model, name: "m1") }
  let(:m2) { create(:model, name: "m2") }
  let(:m3) { create(:model, name: "m3") }
  let(:analysis) { create(:analysis, possible_models: [m1, m2, m3]) }

  subject { As2Init.new(analysis) }

  it 'should have 3 possible models' do
    expect(analysis.possible_models.size).to eq 3
  end
  it 'should return all model rules as contradictions' do
    expect(subject.send(:model_rules).length).to eq 6
  end

  it 'should have 2 subclasses' do
    expect(Preferences::AS2.subclasses.length).to eq 2
  end

end
