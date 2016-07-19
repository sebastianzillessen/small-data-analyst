require 'rails_helper'

RSpec.describe Preference, type: :model do
  subject { create(:preference) }

  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:research_question) }
  it { is_expected.to respond_to(:stage) }
  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:int_name) }
  it { is_expected.to respond_to(:preference_arguments) }
  it { is_expected.to respond_to(:global) }

  it 'should be able to delete' do
    expect(subject.destroy).to be_truthy
  end

  # todo: Test order_string, order_string=

  describe 'with cd1' do
    subject { FactoryGirl.create(:preference_cd1) }
    it { expect(subject.arguments.count).to be 2 }

    let(:result) {
      {
          "cd1_mild": ["cd1_mild",
                       "cd1_mild -> (weibull -> cox_proportional_hazard)",
                       "cd1_mild -> (weibull -> kaplan_meier)"],
          "cd1_heavy": ["cd1_heavy", "cd1_heavy -> (weibull -> cox_proportional_hazard)",
                        "cd1_heavy -> (kaplan_meier -> cox_proportional_hazard)"]
      }.deep_symbolize_keys
    }

    it "should return the right rules" do
      expect(subject.all_rules.deep_symbolize_keys).to match_hash(result.deep_symbolize_keys)
    end

    it "should return the right rules for one assumption only" do
      expect(subject.rules("cd1_mild")).to match_array(result.deep_symbolize_keys[:cd1_mild])
    end

    it "should return the right rules for one assumption only" do
      expect(subject.rules("cd1_heavy")).to match_array(result.deep_symbolize_keys[:cd1_heavy])
    end
  end


  describe 'stage 1-10 registered for statisticians only' do
    let(:non_statistician) { create(:user) }
    context 'a statistician' do
      let(:statistician) { create(:statistician) }
      before(:each) { subject.user = statistician }
      it 'should be allowed to set stage to 1' do
        subject.stage = 1
        expect(subject).to be_valid
      end
      it 'should not be allowed to set stage to 10' do
        subject.stage = 10
        expect(subject).to be_valid
      end
    end

    context 'a clinician' do
      let(:clinician) { create(:clinician) }
      before(:each) { subject.user = clinician }
      it 'should not be allowed to set stage to 1' do
        subject.stage = 1
        expect(subject).not_to be_valid
      end

      it 'should not be allowed to set stage to 10' do
        subject.stage = 10
        expect(subject).to be_valid
      end
    end
  end
end
