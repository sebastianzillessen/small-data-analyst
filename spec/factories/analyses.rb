FactoryGirl.define do
  factory :analysis do
    in_progress true
    research_question
    dataset
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
    sequence(:name) { |n| "Kaplan Meier #{n}" }
    after :build do |m|
      m.assumptions << QueryAssumption.find_or_create_by(critical: true, name: "a1", question: "non informative censoring")
      m.assumptions << TestAssumption.find_or_create_by(critical: false, name: "a2", description: "heavy censoring", r_code: "result <- TRUE")
    end
  end

  factory :cox_model, parent: :model do
    sequence(:name) { |n| "Cox Proportional Hazard #{n}" }
    after :build do |m|
      m.assumptions << QueryAssumption.find_or_create_by(critical: true, name: "a1", question: "non informative censoring")
      m.assumptions << TestAssumption.find_or_create_by(critical: false, name: "a2", description: "heavy censoring", r_code: "result <- TRUE")
      m.assumptions << TestAssumption.find_or_create_by(critical: true, name: "a3", description: "proportional hazards", r_code: "result <- FALSE")
    end
  end

  factory :weibul_model, parent: :model do
    sequence(:name) { |n| "Weibull #{n}" }
    after :build do |m|
      m.assumptions << QueryAssumption.find_or_create_by(critical: true, name: "a1", question: "non informative censoring")
      m.assumptions << TestAssumption.find_or_create_by(critical: false, name: "a2", description: "heavy censoring", r_code: "result <- TRUE")
      m.assumptions << TestAssumption.find_or_create_by(critical: true, name: "a4", description: "linear relation", r_code: "result <- FALSE")
    end
  end


  factory :dataset_survival, parent: :dataset do
    name "ovarian.csv"
    data <<EOF
"","futime","fustat","age","resid.ds","rx","ecog.ps"
"1",59,1,72.3315,2,1,1
"2",115,1,74.4932,2,1,1
"3",156,1,66.4658,2,1,2
"4",421,0,53.3644,2,2,1
"5",431,1,50.3397,2,1,1
"6",448,0,56.4301,1,1,2
"7",464,1,56.937,2,2,2
"8",475,1,59.8548,2,2,2
"9",477,0,64.1753,2,1,1
"10",563,1,55.1781,1,2,2
"11",638,1,56.7562,1,1,2
"12",744,0,50.1096,1,2,1
"13",769,0,59.6301,2,2,2
"14",770,0,57.0521,2,2,1
"15",803,0,39.2712,1,1,1
"16",855,0,43.1233,1,1,2
"17",1040,0,38.8932,2,1,2
"18",1106,0,44.6,1,1,1
"19",1129,0,53.9068,1,2,1
"20",1206,0,44.2055,2,2,1
"21",1227,0,59.589,1,2,2
"22",268,1,74.5041,2,1,2
"23",329,1,43.137,2,1,1
"24",353,1,63.2192,1,2,2
"25",365,1,64.4247,2,2,1
"26",377,0,58.3096,1,2,1
EOF
    columns ["", "futime", "fustat", "age", "resid.ds", "rx", "ecog.ps"]
  end

  factory :research_question_survival, parent: :research_question do
    name "Survival Analysis"
    after :build do |rq|
      # assign Kaplan Meier, Cox Proportional Hazard & Weibul
      rq.models << create(:kaplan_meier_model)
      rq.models << create(:cox_model)
      rq.models << create(:weibul_model)
    end
  end
  factory :analysis_survival, class: Analysis do
    in_progress true
    association :research_question, :factory => :research_question_survival
    association :dataset, :factory => :dataset_survival

  end
end
