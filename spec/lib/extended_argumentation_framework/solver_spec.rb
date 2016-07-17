require 'rails_helper'


RSpec.describe ExtendedArgumentationFramework::Solver, type: :class do

  def new_arg(args)
    ExtendedArgumentationFramework::Argument.new(args)
  end

  let(:framework) { build(:framework_example) }
  subject { ExtendedArgumentationFramework::Solver.new(framework) }


  # outcome:
  # Arguments IN: a1, a3, b1, b4, c1, c2,
  # Arguments OUT: a2, b2, b3
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

  context 'with acceptability check' do
    let(:framework) { ExtendedArgumentationFramework::Framework.new("y1,y2,y3,y4,y5,z1,z2,z3,z4,z5,x,y1->(z1->y2),y3->(z2->y2),y2->(z3->y3),y4->(z3->y3),z4->y4,z5->(y5->x),y2->x") }
    let(:z1to5) { framework.arguments.select { |a| a.name.start_with?("z") } }
    let(:z1) { new_arg("z1") }
    let(:x) { new_arg("x") }
    it { expect(framework.attacks.length).to be 6 }
    it { expect(framework.attacks_on_attacks.length).to be 5 }
    it { expect(framework.arguments.length).to be 11 }

    it 'z1to5 should be an array of arguments' do
      expect(z1to5).to be_an Array
      z1to5.each { |x| expect(x).to be_an ExtendedArgumentationFramework::Argument }
    end

    it 'should be acceptable wrt. [z1,..z5]' do
      expect(subject.acceptable_arguments(z1to5, x)).to be_truthy
    end

    it 'should not be acceptable wrt. [z1]' do
      expect(subject.acceptable_arguments([z1], x)).to be_falsey
    end
  end


  context 'with 3 models each attacking each other' do
    let(:fw_string) {
      [
          "m1,m2,m3,CD1_mild,CD1_heavy,CD2_explain,CD2_predict",
          "TEST",
          "m1->m2, m1->m3, m2->m1, m2->m3, m3->m1, m3->m2",
          "CD1_no",
          "CD1_mild -> (m3->m2), CD1_mild -> (m3->m1)",
          "CD1_heavy -> (m3->m2), CD1_heavy -> (m3->m1)",
          "CD1_heavy -> (m1->m3), CD1_heavy -> (m1->m2)",
          "CD2_predict -> (m3->m2), CD2_predict -> (m3->m1)",
          "CD2_predict -> (m1->m2), CD2_predict -> (m1->m3)",
          "CD2_explain -> (m2->m1), CD2_explain -> (m3-> m1)",
          "CD2_explain -> (m1->m2), CD2_explain -> (m3-> m2)",
          "TEST -> (m2->m1)"
      ].join(",")
    }
    let(:m1) { new_arg("m1") }
    let(:m2) { new_arg("m2") }
    let(:m3) { new_arg("m3") }
    let(:cd1_no) { new_arg("CD1_no") }
    let(:cd1_mild) { new_arg("CD1_mild") }
    let(:cd1_heavy) { new_arg("CD1_heavy") }
    let(:cd2_predict) { new_arg("CD2_predict") }
    let(:cd2_explain) { new_arg("CD2_explain") }
    let(:test) { new_arg("TEST") }

    let(:framework) { ExtendedArgumentationFramework::Framework.new(fw_string) }

    context 'with CD1_heavy in place' do
      it 'should return true for m2 ' do
        expect(subject.acceptable_arguments([cd1_heavy], m2)).to be_truthy
      end
      it 'should return false for m1 and m3 ' do
        expect(subject.acceptable_arguments([cd1_heavy], m1)).to be false
        expect(subject.acceptable_arguments([cd1_heavy], m3)).to be false
      end

      it 'should return false for m1' do
        expect(subject.acceptable_arguments([cd1_heavy], m1)).to be false
      end
      it 'should return false for m3 ' do
        expect(subject.acceptable_arguments([cd1_heavy], m3)).to be false
      end
    end

    context 'with CD1_mild in place' do
      it 'should return not decidable for acceptable for any m_1 and m2' do
        expect(subject.acceptable_arguments([cd1_mild], m1)).to be_nil
        expect(subject.acceptable_arguments([cd1_mild], m2)).to be_nil
      end
      it 'should return not accceptable for m3' do
        expect(subject.acceptable_arguments([cd1_mild], m3)).to be false
      end
    end

    context 'with CD2_predict in place' do
      it 'should return true for m2 ' do
        expect(subject.acceptable_arguments([cd2_predict], m2)).to be_truthy
      end

      it 'should return false for m1 and m3' do
        expect(subject.acceptable_arguments([cd2_predict], m1)).to be_falsey
        expect(subject.acceptable_arguments([cd2_predict], m1)).not_to be_nil
        expect(subject.acceptable_arguments([cd2_predict], m3)).to be_falsey
        expect(subject.acceptable_arguments([cd2_predict], m3)).not_to be_nil
      end
    end

    context 'with CD2_explain in place' do
      it 'should return true for m2 ' do
        expect(subject.acceptable_arguments([cd2_explain], m2)).to be_truthy
        expect(subject.acceptable_arguments([cd2_explain], m1)).to be_truthy
      end

      it 'should return false for m1 and m3' do
        expect(subject.acceptable_arguments([cd2_explain], m3)).to be false
        expect(subject.acceptable_arguments([cd2_explain], m3)).not_to be_nil
      end
    end

    context 'chaining CD1_mild and CD2_predict' do
      it 'should return m2 as only possible model' do
        expect(subject.chain(m2, [cd1_mild], [cd2_predict]).first).to be_truthy
      end

      it 'should return m2 as only possible model on second level' do
        expect(subject.chain(m2, [cd1_mild], [cd2_predict]).last).to match_array([[cd1_mild], [cd2_predict]])
      end

      it 'should declare m3 as not possible model' do
        expect(subject.chain(m3, [cd1_mild], [cd2_predict]).first).to eq false
      end

      it 'should declare m1 as not possible model' do
        expect(subject.chain(m1, [cd1_mild], [cd2_predict]).first).to eq false
      end
    end
    context 'chaining CD2_predict and test' do
      it 'should return m2 as only possible model on first level' do
        expect(subject.chain(m2, [cd2_predict], [test]).last).to match_array([[cd2_predict]])
      end

      it 'should return m2 as only possible model ' do
        expect(subject.chain(m2, [cd2_predict], [test]).first).to be_truthy
      end
    end
    context 'chaining CD1_mild only ' do
      it 'should return m1 as undecided model' do
        expect(subject.chain(m1, [cd1_mild]).first).to be_nil
      end

      it 'should return m2 as undec model' do
        expect(subject.chain(m2, [cd1_mild]).first).to be_nil
      end
      it 'should return m3 as non possible model' do
        expect(subject.chain(m3, [cd1_mild]).first).to eq false
      end
    end

    context 'chaining CD1_mild and TEST' do
      it 'should return m1 as only possible model' do
        expect(subject.chain(m1, [cd1_mild], [test]).first).to be_truthy
      end

      it 'should declare m3 as not possible model' do
        expect(subject.chain(m3, [cd1_mild], [test]).first).to eq false
      end

      it 'should declare m2 as not possible model' do
        expect(subject.chain(m2, [cd1_mild], [test]).first).to eq false
        expect(subject.chain(m2, [cd1_mild], [test]).first).not_to be_nil
      end
    end

  end

end
