FactoryGirl.define do
  factory :analysis do
    in_progress true
    research_question
    dataset
    association :user, factory: :user
  end
  trait :with_models do
    transient do
      number_of_models 3
    end
    after :create do |analysis, eval|
      create_list :model, eval.number_of_models, research_questions: [analysis.research_question]
    end
  end

  factory :kaplan_meier_model, parent: :model do
    name "Kaplan Meier"
    after :build do |m|
      m.assumptions << (QueryAssumption.find_by(name: "a1") || QueryAssumption.create(name: "a1", question: "non informative censoring"))
      m.assumptions << (TestAssumption.find_by(name: "a2") || TestAssumption.create(name: "a2", description: "heavy censoring", r_code: "result <- TRUE"))
    end
  end

  factory :cox_model, parent: :model do
    name "Cox Proportional Hazard"
    after :build do |m|
      m.assumptions << (QueryAssumption.find_by(name: "a1") || QueryAssumption.create(name: "a1", question: "non informative censoring"))
      m.assumptions << (TestAssumption.find_by(name: "a2") || TestAssumption.create(name: "a2", description: "heavy censoring", r_code: "result <- TRUE"))
      m.assumptions << (TestAssumption.find_by(name: "a3") || TestAssumption.create(name: "a3", description: "proportional hazards", r_code: "result <- FALSE"))
    end
  end

  factory :weibul_model, parent: :model do
    name "Weibull"
    after :build do |m|
      m.assumptions << (QueryAssumption.find_by(name: "a1") || QueryAssumption.create(name: "a1", question: "non informative censoring"))
      m.assumptions << (TestAssumption.find_by(name: "a2") || TestAssumption.create(name: "a2", description: "heavy censoring", r_code: "result <- TRUE"))
      m.assumptions << (TestAssumption.find_by(name: "a4") || TestAssumption.create(name: "a4", description: "linear relation", r_code: "result <- TRUE"))
    end
  end


  factory :dataset_survival, parent: :dataset do
    name "ovarian.csv"
    data IO.read(Rails.root.join("db/data/ovarian.csv"))
    columns ["", "futime", "fustat", "age", "resid.ds", "rx", "ecog.ps"]
  end

  factory :research_question_survival, parent: :research_question do
    name "Survival Analysis"
    after :build do |rq|
      # assign Kaplan Meier, Cox Proportional Hazard & Weibul
      rq.models << (Model.find_by(name: "Weibull") || create(:weibul_model))
      rq.models << (Model.find_by(name: "Kaplan Meier")|| create(:kaplan_meier_model))
      rq.models << (Model.find_by(name: "Cox Proportional Hazard") || create(:cox_model))
    end
  end
  factory :analysis_survival, class: Analysis do
    in_progress true
    association :research_question, :factory => :research_question_survival
    association :dataset, :factory => :dataset_survival
  end
end
