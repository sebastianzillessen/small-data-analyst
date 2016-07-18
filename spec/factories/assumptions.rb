FactoryGirl.define do
  factory :assumption do
    name { Faker::Lorem.sentence(4) }
    factory :query_assumption, class: QueryAssumption do
      question "This is a default question"
      factory :qa_cd2_predict do
        name "CD2_predict"
        question "Intention of analysis: predict?"
        description "Preferences for CD2"
      end
      factory :qa_cd2_explain do
        name "CD2_explain"
        question "Intention of analysis: explain?"
        description "Preferences for CD2"

      end
    end
    factory :blank_assumption, class: BlankAssumption do

    end

    factory :test_assumption, class: TestAssumption, parent: :assumption do
      description { Faker::Lorem.sentences(4) }
      fail_on_missing false
      r_code { "result <- TRUE" }
      #after(:build) do |ta|
      #  allow(ta).to receive(:eval_internal){true}
      #end

      factory :ta_cd1_mild do
        name "CD1_mild"
        r_code "#no censoring = 0, mild censoring < 0.7, heavy censoring >= 0.7
            censoring.prop<-(nrow(tabular_data)-sum(tabular_data$fustat))/nrow(tabular_data)
            result <- (censoring.prop < 0.7)"
        required_dataset_fields ['fustat']
        #after(:build) do |ta|
        #  allow(ta).to receive(:eval_internal){true}
        #end
      end

      factory :ta_cd1_heavy do
        name "CD1_heavy"
        r_code "#no censoring = 0, mild censoring < 0.7, heavy censoring >= 0.7
            censoring.prop<-(nrow(tabular_data)-sum(tabular_data$fustat))/nrow(tabular_data)
            result <- (censoring.prop >= 0.7)"
        required_dataset_fields ['fustat']
        #after(:build) do |ta|
        #  allow(ta).to receive(:eval_internal){false}
        #end
      end
    end
  end




end