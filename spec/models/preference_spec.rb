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
          "CD1_mild": ["CD1_mild",
                       "CD1_mild -> (weibull -> cox_proportional_hazard)",
                       "CD1_mild -> (weibull -> kaplan_meier)"],
          "CD1_heavy": ["CD1_heavy", "CD1_heavy -> (weibull -> cox_proportional_hazard)",
                        "CD1_heavy -> (kaplan_meier -> cox_proportional_hazard)"]
      }.deep_symbolize_keys
    }

    it "should return the right rules" do
      expect(subject.all_rules.deep_symbolize_keys).to match_hash(result.deep_symbolize_keys)
    end

    it "should return the right rules for one assumption only" do
      expect(subject.rules("CD1_mild")).to match_array(result.deep_symbolize_keys[:CD1_mild])
    end

    it "should return the right rules for one assumption only" do
      expect(subject.rules("CD1_heavy")).to match_array(result.deep_symbolize_keys[:CD1_heavy])
    end
  end


end
