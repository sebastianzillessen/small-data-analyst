require 'rails_helper'


RSpec.describe ExtendedArgumentationFramework::Labelling, type: :class do

  let(:framework) { ExtendedArgumentationFramework::Framework.new("a,b,a->b") }
  let(:labelling) { ExtendedArgumentationFramework::Labelling.new(framework) }
  subject { labelling }
  let(:a) { ExtendedArgumentationFramework::Argument.new("a") }
  let(:b) { ExtendedArgumentationFramework::Argument.new("b") }
  let(:c) { ExtendedArgumentationFramework::Argument.new("c") }


  describe '#set' do
    context 'for arguments' do
      it 'should be inlabeled' do
        expect(labelling.arg_in).to include(a)
        expect(labelling.arg_out).not_to include(a)
        expect(labelling.arg_undec).not_to include(a)
      end
      it 'should change label to out' do
        labelling.set(a, ExtendedArgumentationFramework::Labels::OUT)
        expect(labelling.arg_out).to include(a)
      end

      it 'should change label to undec' do
        labelling.set(a, ExtendedArgumentationFramework::Labels::UNDEC)
        expect(labelling.arg_undec).to include(a)
      end
    end
  end

  context 'with all In labelling' do
    it 'a should be legally labelled in' do
      expect(a.legally_in?(labelling)).to be_truthy
    end

    it 'a should not be illegally labelled in' do
      expect(a.illegally_in?(labelling)).to be_falsey
    end
    it 'b should be illegally labelled in' do
      expect(b.illegally_in?(labelling)).to be_truthy
    end

    it 'b should not be legally labelled in' do
      expect(b.legally_in?(labelling)).to be_falsey
    end

    it { is_expected.not_to be_admissible }
  end
  context 'with correct labelling' do
    before(:each) {
      labelling.set(a, ExtendedArgumentationFramework::Labels::IN)
      labelling.set(b, ExtendedArgumentationFramework::Labels::OUT)
      labelling.set(framework.edges.first, ExtendedArgumentationFramework::Labels::IN)
    }

    it 'a should be legally labelled in' do
      expect(a.legally_in?(labelling)).to be_truthy
    end

    it 'a should not be legally labelled out' do
      expect(a.legally_out?(labelling)).to be_falsey
    end

    it 'a should not be legally labelled undec' do
      expect(a.legally_undec?(labelling)).to be_falsey
    end

    it 'b should be legally labelled out' do
      expect(b.legally_out?(labelling)).to be_truthy
    end

    it 'b should not be legally labelled in' do
      expect(b.legally_in?(labelling)).to be_falsey
    end


    it { is_expected.to be_admissible }

    it 'b should not be legally labelled undec' do
      expect(b.legally_undec?(labelling)).to be_falsey
    end

    describe '#clone' do
      it 'should equal' do
        expect(labelling.clone).to eq labelling
      end

      it 'should not change properties' do
        l = labelling.clone
        l.set(a, ExtendedArgumentationFramework::Labels::OUT)
        expect(l).not_to eq labelling
      end
    end

  end


  describe 'more complex framework' do
    let(:framework) { ExtendedArgumentationFramework::Framework.new("a,b,c,a->b, c -> (a -> b)") }
    let(:attack) { framework.attacks(a).first }
    let(:attack_on_attack) { framework.attacks_on_attacks.first }


    describe '#clone' do
      it 'should equal' do
        expect(labelling.clone).to eq labelling
      end
    end
    context 'with all In labelling' do
      it 'a should be legally labelled in' do
        expect(a.legally_in?(labelling)).to be_truthy
      end

      it 'a should not be illegally labelled in' do
        expect(a.illegally_in?(labelling)).to be_falsey
      end

      it 'b should be in in' do
        expect(labelling.arg_in).to include b
      end

      it 'b should not be legally in' do
        expect(b.legally_in?(labelling)).to be_falsey
      end
      it 'b should be illegally labelled in' do
        expect(b.illegally_in?(labelling)).to be_truthy
      end

      it 'should label attack on attack in' do
        expect(attack_on_attack.legally_in?(labelling)).to be_truthy
      end

      it 'should not label attack on attack out' do
        expect(attack_on_attack.legally_out?(labelling)).to be_falsey
      end
      it 'should not label attack on attack undec' do
        expect(attack_on_attack.legally_undec?(labelling)).to be_falsey
      end

      it 'should not label attack in' do
        expect(attack.legally_in?(labelling)).to be_falsey
      end

      it 'should not label attack undec' do
        expect(attack.legally_undec?(labelling)).to be_falsey
      end


      it 'should label attack out' do
        expect(attack.legally_out?(labelling)).to be_truthy
      end

      it { is_expected.not_to be_admissible }
    end
    context 'with correct labelling' do
      before(:each) {
        labelling.set(a, ExtendedArgumentationFramework::Labels::IN)
        labelling.set(b, ExtendedArgumentationFramework::Labels::IN)
        labelling.set(attack, ExtendedArgumentationFramework::Labels::OUT)
        labelling.set(attack_on_attack, ExtendedArgumentationFramework::Labels::IN)
      }

      it 'a should be legally labelled in' do
        expect(a.legally_in?(labelling)).to be_truthy
      end

      it 'a should not be legally labelled out' do
        expect(a.legally_out?(labelling)).to be_falsey
      end

      it 'a should not be legally labelled undec' do
        expect(a.legally_undec?(labelling)).to be_falsey
      end

      it 'b should be legally labelled in' do
        expect(b.legally_in?(labelling)).to be_truthy
      end

      it 'b should not be legally labelled out' do
        expect(b.legally_out?(labelling)).to be_falsey
      end


      it { is_expected.to be_admissible }

      it 'b should not be legally labelled undec' do
        expect(b.legally_undec?(labelling)).to be_falsey
      end
    end
  end

end