require 'rails_helper'

RSpec.describe BlankAssumption, type: :model do

  subject { BlankAssumption.new }

  describe 'general BlankAssumptions' do
    it { expect(subject).to respond_to :assumptions }
    it { expect(subject).to respond_to :assumptions}
  end

  describe 'assumptions and assumptions' do
    subject { FactoryGirl.create(:blank_assumption) }
    it { expect(subject.assumptions).to be_empty }
    it { expect(subject.assumptions).to be_empty }
  end
  describe 'attributes access' do
    it { pending("How to hide attributes in STI"); is_expected.not_to respond_to :name }
    it { pending("How to hide attributes in STI"); is_expected.not_to respond_to :description }
    it { pending("How to hide attributes in STI"); is_expected.not_to respond_to :required_dataset_fields }
    it { pending("How to hide attributes in STI"); is_expected.not_to respond_to :fail_on_missing }
    it { pending("How to hide attributes in STI"); is_expected.not_to respond_to :r_code }
    it { pending("How to hide attributes in STI"); is_expected.not_to respond_to :question }
    it { pending("How to hide attributes in STI"); is_expected.not_to respond_to :argument_inverted }
  end


end
