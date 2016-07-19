FactoryGirl.define do

  factory :preference_without_preference_arguments, class: Preference do
    sequence(:name){|n| "MyPref #{n}"}
    stage 10
    user
    association :research_question, strategy: :build, factory: :research_question

    factory :preference do
      after(:build) { |preference|
        preference.preference_arguments = build_list(:preference_argument_without_preference, 2, preference: preference)
      }
    end

    factory :preference_cd1 do
      association :user, factory: :statistician
      stage 1
      research_question do
        ResearchQuestion.find_by(name: "Survival Analysis") || create(:research_question_survival)
      end
      name "CD1"
      preference_arguments do
        weibull = Model.find_by(name: "Weibull") || create(:weibul_model)
        kaplan_meier = Model.find_by(name: "Kaplan Meier")|| create(:kaplan_meier_model)
        cox_proportional_hazards = Model.find_by(name: "Cox Proportional Hazard") || create(:cox_model)
        weibull = "model_#{weibull.id}"
        kaplan_meier = "model_#{kaplan_meier.id}"
        cox_proportional_hazards = "model_#{cox_proportional_hazards.id}"
        ta_cd1_mild = TestAssumption.find_by(name: "CD1_mild") || create(:ta_cd1_mild)
        ta_cd1_heavy = TestAssumption.find_by(name: "CD1_heavy")|| create(:ta_cd1_heavy)
        cd1_mild = PreferenceArgument.new(
            assumption: ta_cd1_mild,
            order_string: "#{weibull},,#{kaplan_meier},#{cox_proportional_hazards}"
        )
        cd1_heavy = PreferenceArgument.new(
            assumption: ta_cd1_heavy,
            order_string: "#{weibull},#{kaplan_meier},,#{cox_proportional_hazards}"
        )
        ta_cd1_mild.attacking = [ta_cd1_heavy]
        ta_cd1_heavy.attacking = [ta_cd1_mild]
        cd1_mild.assumption.save
        cd1_heavy.assumption.save
        [cd1_mild, cd1_heavy]
      end

    end

    factory :preference_cd2 do
      research_question do
        ResearchQuestion.find_by(name: "Survival Analysis") || create(:research_question_survival)
      end
      name "CD2"
      stage 1
      association :user, factory: :statistician
      preference_arguments do
        weibull = Model.find_by(name: "Weibull") || create(:weibul_model)
        kaplan_meier = Model.find_by(name: "Kaplan Meier")|| create(:kaplan_meier_model)
        cox_proportional_hazards = Model.find_by(name: "Cox Proportional Hazard") || create(:cox_model)
        weibull = "model_#{weibull.id}"
        kaplan_meier = "model_#{kaplan_meier.id}"
        cox_proportional_hazards = "model_#{cox_proportional_hazards.id}"

        qa_cd2_explain = QueryAssumption.find_by(name: "CD2_explain") || create(:qa_cd2_explain)
        qa_cd2_predict = TestAssumption.find_by(name: "CD2_predict")|| create(:qa_cd2_predict)
        cd2_explain = PreferenceArgument.new(
            assumption: qa_cd2_explain,
            order_string: "#{weibull},,#{kaplan_meier},#{cox_proportional_hazards}"
        )
        cd2_predict = PreferenceArgument.new(
            assumption: qa_cd2_predict,
            order_string: "#{weibull},#{kaplan_meier},,#{cox_proportional_hazards}"
        )
        qa_cd2_predict.attacking = [qa_cd2_explain]
        qa_cd2_explain.attacking = [qa_cd2_predict]
        cd2_predict.assumption.save
        cd2_explain.assumption.save
        [cd2_explain, cd2_predict]
      end

    end
  end
end
