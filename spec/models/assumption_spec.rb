require 'rails_helper'

RSpec.describe Assumption, type: :model do

  describe 'assumptions in general' do
    subject { Assumption.new }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to respond_to :attackers }
    it { is_expected.to respond_to :models }
  end

  describe 'attackers and attacking' do
    subject { FactoryGirl.create(:assumption) }
    it { expect(subject.attackers).to be_empty }
  end


  describe 'small argumentation framework' do
    subject { FactoryGirl.create(:assumption) }

    describe 'single argument should be critical true' do
      it { is_expected.to respond_to(:evaluate_critical) }
      it { expect(subject.evaluate_critical).to be_truthy }
    end

    it 'argument with no critical attacker should be critical true' do
      subject.attackers << FactoryGirl.create(:assumption)
      expect(subject.evaluate_critical).to be_truthy
    end


    it 'argument with a critical false assumption attacker should be critical false' do
      f= FactoryGirl.create(:critical_assumption)
      allow(f).to receive(:evaluate_critical).and_return(false)
      subject.attackers << f
      expect(subject.evaluate_critical).to be_falsey
    end

    it 'argument with a query critical false assumption attacker should be true as they should be ignored' do
      f= FactoryGirl.create(:critical_query_assumption)
      allow(f).to receive(:evaluate_critical).and_return(false)
      subject.attackers << f
      expect(subject.evaluate_critical).to be_truthy
    end

    it 'should return the query_assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      subject.attackers << f
      expect(subject.get_critical_queries).to eq [f]
    end

    it 'should return the query_assumption of a sub critical blank assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      b= FactoryGirl.create(:critical_blank_assumption)
      b.attackers << f
      subject.attackers << b
      expect(subject.get_critical_queries).to eq [f]
    end

    it 'should not return the query_assumption of a sub non-critical blank assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      b= FactoryGirl.create(:blank_assumption)
      b.attackers << f
      subject.attackers << b
      expect(subject.get_critical_queries).to be_empty
    end


    it 'should not return the query_assumption of a sub critical blank assumption that has a critical evaluating to false assumption' do
      f= FactoryGirl.create(:critical_query_assumption)
      b= FactoryGirl.create(:critical_blank_assumption)
      w= FactoryGirl.create(:critical_blank_assumption)
      allow(w).to receive(:evaluate_critical).and_return(false)
      b.attackers << f
      subject.attackers << b
      subject.attackers << w
      expect(subject.get_critical_queries).to be_empty
    end


    it 'argument with a critical assumption attacker should be critical true' do
      f= FactoryGirl.create(:critical_assumption)
      subject.attackers << f
      expect(subject.evaluate_critical).to be_truthy
    end
  end


end
