require 'rails_helper'


RSpec.describe ExtendedArgumentationFramework::Framework, type: :class do
  let(:a1) { ExtendedArgumentationFramework::Argument.new("a_1") }
  let(:a2) { ExtendedArgumentationFramework::Argument.new("a_2") }
  let(:a3) { ExtendedArgumentationFramework::Argument.new("a_3") }

  let(:arguments) { [a1, a2, a3] }
  let(:attacks) { [ExtendedArgumentationFramework::Edge.new(a1, a2)] }
  let(:attacks_on_attacks) { [ExtendedArgumentationFramework::Edge.new(a3, ExtendedArgumentationFramework::Edge.new(a1, a2))] }

  subject { ExtendedArgumentationFramework::Framework.new(arguments, attacks, attacks_on_attacks) }


  describe '#arguments' do
    it { is_expected.to respond_to(:arguments) }
    it { expect(subject.arguments).to match_array(arguments) }
  end

  describe '#attacks' do
    it { is_expected.to respond_to(:attacks) }
    it { expect(subject.attacks).to match_array(attacks) }
  end

  describe '#attacks_on_attacks' do
    it { is_expected.to respond_to(:attacks_on_attacks) }
    it { expect(subject.attacks_on_attacks).to match_array(attacks_on_attacks) }

    it 'should only return the attacks_on_attacks of a given source' do
      expect(subject.attacks_on_attacks(a3)).to match_array(attacks_on_attacks)
      expect(subject.attacks_on_attacks(a1)).to match_array([])
    end
  end
  describe '#edges' do
    it 'should return attacks and attacks_on_attacks ' do
      expect(subject.edges).to match_array(attacks + attacks_on_attacks)
    end
  end

  describe '#parse' do
    subject { build(:framework) }
    it 'should have 3 arguments' do
      expect(subject.arguments.length).to eq 3
    end

    it 'should match 3 arguments' do
      expect(subject.arguments).to match_array(%w(a b c).map { |s| ExtendedArgumentationFramework::Argument.new(s) })
    end

    it 'should have 2 attack' do
      expect(subject.attacks.length).to eq 2
    end
    it 'should have one attack on attacks' do
      expect(subject.attacks_on_attacks.length).to eq 1
    end


    it 'should have one attack on attacks' do
      expect(subject.attacks_on_attacks.first).to eq ExtendedArgumentationFramework::Edge.new(ExtendedArgumentationFramework::Argument.new("a"), ExtendedArgumentationFramework::Edge.new(ExtendedArgumentationFramework::Argument.new("b"), ExtendedArgumentationFramework::Argument.new("c")))
    end

    it 'should throw an error if no counterattack available' do
      expect { ExtendedArgumentationFramework::Framework.new("a, b -> c, a -> (b -> c)", enforce_counter_attack: true) }.to raise_error(RuntimeError, "The counter attack for ((a) -> ((b) -> (c)))->((b) -> (c)) is missing in the set of attacks")
    end
  end


  describe 'framework' do
    subject { build(:framework_example) }

    it 'should have 9 arguments' do
      expect(subject.arguments.length).to eq 9
    end

    it 'should have 7 edges' do
      expect(subject.attacks.length).to eq 7
    end

    it 'should have 5 attacks on attacks' do
      expect(subject.attacks_on_attacks.length).to eq 5
    end

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
    end


  end
end
