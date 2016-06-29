class AddDefaultModels < ActiveRecord::Migration
  def load_data(file)
    IO.read(Rails.root.join("db/data/#{file}"))
  end

  def self.up
    # Create ovarian DB
    ovarian = Dataset.create(name: 'ovarian', description: 'Contains the survival in a randomised trial comparing two treatments for ovarian cancer',
                             data: load_data('ovarian.csv'),
                             columns: ["", "futime", "fustat", "age", "resid.ds", "rx", "ecog.ps"])

    # Create objective
    o1 = ResearchQuestion.create(name: 'Survival analysis',
                                 description: 'Is there a difference in the survival between the patients?')
    # Create m1, m2, m3
    m1 = Model.create(name: 'Kaplan Meier', research_questions: [o1])
    m2 = Model.create(name: 'Cox Proportional Hazards', research_questions: [o1])
    m3 = Model.create(name: 'Weibull', research_questions: [o1])

    m1.research_questions << o1
    m2.research_questions << o1
    m3.research_questions << o1

    # Create assumptions a1, a2, a3, a4
    # TODO: Fill in proper code
    a1 = QueryAssumption.create(name: "a1", critical: true, description: "non informative censoring", question: "Has non-informative censoring been in place?")
    a2 = TestAssumption.create(name: "a2", critical: false, description: "heavy censoring", r_code: load_data('a2.r'))
    a3 = TestAssumption.create(name: "a3", critical: true, description: "proportional hazards", r_code: load_data('a3.r'))
    a4 = TestAssumption.create(name: "a4", critical: true, description: "linear relation", r_code: load_data('a4.r'))

    a5 = BlankAssumption.create(name: "a5", critical: true, description: "Test Assumption for grouping other assumptions")
    a6 = QueryAssumption.create(name: "a6", critical: true, description: "clinician should confirm that he knows what he is doing", question: "Do you know, what you are doing?")
    a7 = TestAssumption.create(name: "a7", critical: true, description: "dataset larger then 10", r_code: load_data('a7.r'))

    # assign assumptions
    a5.assumptions << a6
    a5.assumptions << a7

    m1.assumptions << a1
    m1.assumptions << a2
    m1.assumptions << a5

    m2.assumptions << a1
    m2.assumptions << a2
    m2.assumptions << a3

    m3.assumptions << a1
    m3.assumptions << a2
    m3.assumptions << a4


    if m1.save && m2.save && m3.save
      puts "Seeds run correctly"
    else
      puts "There was a problem running the seeds"
    end

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
