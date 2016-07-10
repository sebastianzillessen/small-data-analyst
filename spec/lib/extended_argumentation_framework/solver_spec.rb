require 'rails_helper'


RSpec.describe ExtendedArgumentationFramework::Solver, type: :class do

  let(:framework) { build(:framework_example) }
  subject { ExtendedArgumentationFramework::Solver.new(framework) }


  # outcome:
  # Arguments IN: c2, b4, a3, a1, b1, c1
  # Arguments OUT: b3, a2, b2
  # Arguments UNDEC: -
  # Edges IN:
  # - b4 -> b3
  # - a3 -> a2
  # - a2 -> a1
  # - b1 -> b2
  # Edges OUT:
  # - b3 -> b4
  # - a1 -> a2
  # - b2 -> b1

  it 'should return one preferred extension' do
    expect(subject.preferred_extensions.length).to eq 1
  end

  context 'with acceptability check' do
    let(:framework) { ExtendedArgumentationFramework::Framework.new("y1->(z1->y2),y3->(z2->y2),y2->(z3->y3),y4->(z3->y3),z4->y4,z5->(y5->x),y2->x") }
    let(:z1to5) { framework.arguments.select { |a| a.name.start_with?("z") } }
    let(:z1) { ExtendedArgumentationFramework::Argument.new("z1") }
    let(:x) { ExtendedArgumentationFramework::Argument.new("x") }
    it { expect(framework.attacks.length).to be 6 }
    it { expect(framework.attacks_on_attacks.length).to be 5 }
    it { expect(framework.arguments.length).to be 11 }

    it 'should be acceptable wrt. [z1,..z5]' do
      expect(subject.acceptable_arguments(z1to5, x)).to be_truthy
    end

    it 'should not be acceptable wrt. [z1]' do
      expect(subject.acceptable_arguments([z1], x)).to be_falsey
    end
  end


end
