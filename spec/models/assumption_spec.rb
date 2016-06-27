require 'rails_helper'

RSpec.describe Assumption, type: :model do

  describe 'assumptions in general' do
    subject { Assumption.new }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.not_to respond_to :assumptions }
    it { is_expected.to respond_to :required_by }
    it { is_expected.to respond_to :models }
  end

  describe 'assumptions and assumptions' do
    subject { FactoryGirl.create(:assumption) }
    it { expect(subject.required_by).to be_empty }
  end


  describe 'small argumentation framework' do
    subject { FactoryGirl.create(:blank_assumption) }
    let(:analysis) { create(:analysis) }

    describe 'single argument should be critical true' do
      it { is_expected.to respond_to(:evaluate_critical) }
      it { expect(subject.evaluate_critical(analysis)).to be_truthy }
    end

    it 'argument with no critical attacker should be critical true' do
      subject.assumptions << FactoryGirl.create(:assumption)
      expect(subject.evaluate_critical(analysis)).to be_truthy
    end


    it 'argument with a critical false assumption attacker should be critical false' do
      f= FactoryGirl.create(:critical_test_assumption, r_code: "result <- FALSE")
      subject.assumptions << f
      expect(subject.evaluate_critical(analysis)).to be_falsey
    end

    it 'argument with a query critical false assumption attacker should be true as they should be ignored' do
      f= FactoryGirl.create(:critical_query_assumption)
      allow(f).to receive(:evaluate_critical).and_return(false)
      subject.assumptions << f
      expect(subject.evaluate_critical(analysis)).to be_truthy
    end

    it 'should return the query_assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      subject.assumptions << f
      expect(subject.get_critical_queries(analysis)).to eq [f]
    end

    it 'should return the query_assumption of a sub critical blank assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      b= FactoryGirl.create(:critical_blank_assumption)
      b.assumptions << f
      subject.assumptions << b
      expect(subject.get_critical_queries(analysis)).to eq [f]
    end

    it 'should not return the query_assumption of a sub non-critical blank assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      b= FactoryGirl.create(:blank_assumption)
      b.assumptions << f
      subject.assumptions << b
      expect(subject.get_critical_queries(analysis)).to be_empty
    end


    it 'should not return the query_assumption of a sub critical blank assumption that has a critical evaluating to false assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      b= FactoryGirl.create(:critical_blank_assumption)
      w= FactoryGirl.create(:critical_blank_assumption)
      allow(w).to receive(:evaluate_critical).with(analysis).and_return(false)
      b.assumptions << f
      subject.assumptions << b
      subject.assumptions << w
      expect(subject.get_critical_queries(analysis)).to be_empty
    end


    it 'argument with a critical assumption attacker should be critical true' do
      f= FactoryGirl.create(:critical_test_assumption)
      subject.assumptions << f
      expect(subject.evaluate_critical(analysis)).to be_truthy
    end
  end


  describe '#get_all_parents' do
    subject { create(:blank_assumption) }
    let(:a2) { create(:blank_assumption, required_by: [subject]) }
    it 'should return empty for single assumption' do
      expect(subject.get_all_parents).to eq []
    end
    it 'should return only parent' do
      expect(a2.get_all_parents).to include subject
      expect(a2.get_all_parents).not_to include a2
    end

    it 'should return itself if there is a circle' do
      # a2 -> subject -> a2
      subject.required_by << a2
      expect(a2.get_all_parents).to include(subject)
    end

    it 'should be invalid with a circle' do
      # a2 -> subject -> a2
      subject.required_by << a2
      expect(subject).not_to be_valid
    end

    it 'should be valid without a circle' do
      # a2 -> subject
      expect(a2).to be_valid
      expect(subject).to be_valid
    end
  end

end
