# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


def load_data(file)
  IO.read(Rails.root.join("db/data/#{file}"))
end

# Create ovarian DB
ovarian = Dataset.find_or_create_by(name: 'ovarian', description: 'Contains the survival in a randomised trial comparing two treatments for ovarian cancer',
                                    data: load_data('ovarian.csv'),
                                    columns: ["", "futime", "fustat", "age", "resid.ds", "rx", "ecog.ps"])

# Create objective
o1 = ResearchQuestion.find_or_create_by(name: 'Survival analysis',
                                        description: 'Is there a difference in the survival between the patients?')
# Create m1, m2, m3
m1 = Model.find_or_create_by(name: 'Kaplan Meier')
m2 = Model.find_or_create_by(name: 'Cox Proportional Hazards')
m3 = Model.find_or_create_by(name: 'Weibull')

m1.research_questions << o1 unless m1.research_questions.include? o1
m2.research_questions << o1 unless m2.research_questions.include? o1
m3.research_questions << o1 unless m3.research_questions.include? o1

# Create assumptions a1, a2, a3, a4
# TODO: Fill in proper code
a1 = QueryAssumption.find_or_create_by(name: "a1", critical: true, description: "non informative censoring", question: "Has non-informative censoring been in place?")
a2 = TestAssumption.find_or_create_by(name: "a2", critical: false, description: "heavy censoring", r_code: load_data('a2.r'))
a3 = TestAssumption.find_or_create_by(name: "a3", critical: true, description: "proportional hazards", r_code: load_data('a3.r'))
a4 = TestAssumption.find_or_create_by(name: "a4", critical: true, description: "linear relation", r_code: load_data('a4.r'))

a5 = BlankAssumption.find_or_create_by(name: "a5", critical: true, description: "Test Assumption for grouping other assumptions")
a6 = QueryAssumption.find_or_create_by(name: "a6", critical: true, description: "clinician should confirm that he knows what he is doing", question: "Do you know, what you are doing?")
a7 = TestAssumption.find_or_create_by(name: "a7", critical: true, description: "dataset larger then 10", r_code: load_data('a7.r'))


# assign assumptions
a5.assumptions << a6 unless a5.assumptions.include? a6
a5.assumptions << a7 unless a5.assumptions.include? a7

m1.assumptions << a1 unless m1.assumptions.include? a1
m1.assumptions << a2 unless m1.assumptions.include? a2
m1.assumptions << a5 unless m1.assumptions.include? a5

m2.assumptions << a1 unless m2.assumptions.include? a1
m2.assumptions << a2 unless m2.assumptions.include? a2
m2.assumptions << a3 unless m2.assumptions.include? a3

m3.assumptions << a1 unless m3.assumptions.include? a1
m3.assumptions << a2 unless m3.assumptions.include? a2
m3.assumptions << a4 unless m3.assumptions.include? a4


if m1.save && m2.save && m3.save
  puts "Seeds run correctly"
else
  puts "There was a problem running the seeds"
end
