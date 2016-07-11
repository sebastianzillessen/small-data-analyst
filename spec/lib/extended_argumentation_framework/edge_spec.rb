require 'rails_helper'


RSpec.describe ExtendedArgumentationFramework::Edge, type: :class do
  describe '#succeeds_wrt' do
    let(:a1) { ExtendedArgumentationFramework::Argument.new("a1") }
    let(:a2) { ExtendedArgumentationFramework::Argument.new("a2") }
    let(:a3) { ExtendedArgumentationFramework::Argument.new("a3") }
    let(:framework) { ExtendedArgumentationFramework::Framework.new("a3->(a1->a2)") }
    let(:edge) { ExtendedArgumentationFramework::Edge.new(a1, a2) }
    subject { edge }


    it 'should return the subject' do
      expect(framework.attacks_on_attacks(a3).first.target).to eq subject
    end

    it 'should not be accepted w.r.t {a3}' do
      expect(subject.succeeds_wrt([a3], framework)).to be_falsey
    end

    it 'should be accepted w.r.t {}' do
      expect(subject.succeeds_wrt([], framework)).to be_truthy
    end
  end
end
