class AddCdCorrectAssumptions < ActiveRecord::Migration

  def load_data(file)
    IO.read(Rails.root.join("db/data/#{file}"))
  end

  def required_atts(file)
    load_data(file).match(/# required_attributes: (.*)/)[1].split(/\s*,\s*/)
  end

  def self.up
    return
    m1 = Model.find_by(name: 'Kaplan Meier')
    m2 = Model.find_by(name: 'Cox Proportional Hazards')
    m3 = Model.find_by(name: 'Weibull')

    #Assumption.destroy_all

    a1 = QueryAssumption.create(
        name: "a1", critical: true,
        description: "Non-informative censoring",
        question: "Has there non-informative censoring been in place?"
    )
    m1.assumptions << a1
    m2.assumptions << a1
    m3.assumptions << a1

    a2 = TestAssumption.create(
        name: "a2", critical: true,
        description: "Testing for proportional Hazards",
        r_code: load_data('a2-prop-hazards.r'),
        required_attributes: required_atts('a2-prop-hazards.r')
    )
    m2.assumptions << a2

    a3 = TestAssumption.create(
        name: "a3", critical: true,
        description: "Testing for Weibull distribution",
        r_code: load_data('a3-weibull.r'),
        required_attributes: required_atts('a3-weibull.r')
    )
    m3.assumptions << a3
  end

  def self.down
    #raise ActiveRecord::IrreversibleMigration
  end
end
