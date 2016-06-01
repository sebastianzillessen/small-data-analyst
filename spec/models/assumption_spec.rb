require 'rails_helper'

RSpec.describe Assumption, type: :model do

  describe 'assumptions in general' do
    subject { Assumption.new }
    it { expect(subject).to validate_presence_of(:name) }
    it {
      pending
      expect(subject).to validate_presence_of(:type)
    }
    it { expect(subject).to respond_to :attackers }
    it { expect(subject).to respond_to :attacking }
  end

  describe 'attackers and attacking' do
    subject { FactoryGirl.create(:assumption) }
    it { expect(subject.attackers).to be_empty }
    it { expect(subject.attacking).to be_empty }
  end


  describe 'small argumentation framework' do
    subject { FactoryGirl.create(:assumption) }

    describe 'single argument should be critical true' do
      it { is_expected.to respond_to(:evaluate_critical) }
      it { expect(subject.evaluate_critical).to be_truthy }
    end

    it 'argument with no critical attacker should be critical true' do
      subject.attackers << FactoryGirl.create(:false_assumption)
      expect(subject.evaluate_critical).to be_truthy
    end

    it 'argument with a critical false assumption attacker should be critical false' do
      f= FactoryGirl.create(:false_critical_assumption)
      subject.attackers << f
      expect(subject.evaluate_critical).to be_falsey
    end


    it 'argument with a critical assumption attacker should be critical true' do
      f= FactoryGirl.create(:critical_assumption)
      subject.attackers << f
      expect(subject.evaluate_critical).to be_truthy
    end
  end


end
