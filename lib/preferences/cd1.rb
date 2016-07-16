require 'preferences/as2'
module Preferences
  # represents the general preference of:
  # CD1: Heavy censoring
  # unaffected > affected
  # #Proportion of censored cases - a patient is censored if fustat=0
  #   (the event has not been observed yet so we know they
  #   were followed for at leas the value in futime )
  #   no censoring = 0, mild censoring < 0.7, heavy censoring >= 0.7
  #   censoring.prop<-(nrow(ovarian)-sum(ovarian$fustat))/nrow(ovarian)
  # Context Domain | Model | Performance measure
  #   absent          m1 KM   unaffected
  #                   m2 PH   unaffected
  #                   m4 χ2   unaffected
  #   light           m1 KM   unaffected
  #                   m2 PH   unaffected
  #                   m4 χ2   affected
  #   heavy           m1 KM   affected
  #                   m2 PH   unaffected
  #                   m4 χ2   affected

  # so for
  # light censoring we have
  #   m1,m2 > m4
  # which results in the attack rules:
  #   LIGHT -> (m4 -> m2)
  #   LIGHT -> (m4 -> m1)
  # heavy censoring we have
  #   m2 > m1,m4
  # which results in the attack rules:
  #   HEAVY -> (m4 -> m2)
  #   HEAVY -> (m1 -> m2)

  class CD1 < AS2
    def self.stage
      2
    end

    def self.arguments
      cd1_mild = TestAssumption.find_or_initialize_by(name: "CD1_mild") do |a|
        a.r_code = "#no censoring = 0, mild censoring < 0.7, heavy censoring >= 0.7
censoring.prop<-(nrow(tabular_data)-sum(tabular_data$fustat))/nrow(tabular_data)
result <- (censoring.prop < 0.7)"
        a.required_dataset_fields = ['fustat']
        a.save
      end
      cd1_heavy = TestAssumption.find_or_initialize_by(name: "CD1_heavy") do |a|
        a.r_code = "#no censoring = 0, mild censoring < 0.7, heavy censoring >= 0.7
censoring.prop<-(nrow(tabular_data)-sum(tabular_data$fustat))/nrow(tabular_data)
result <- (censoring.prop >= 0.7)"
        a.required_dataset_fields = ['fustat']
        a.save
      end
      [cd1_mild, cd1_heavy]
    end


    protected
    def self.all_rules()
      {
          "CD1_mild": ["CD1_mild",
                       "CD1_mild -> (weibull->cox_proportional_hazards)",
                       "CD1_mild -> (weibull->kaplan_meier)"],
          "CD1_heavy": ["CD1_mild", "CD1_heavy -> (weibull->cox_proportional_hazards)",
                        "CD1_heavy -> (kaplan_meier->cox_proportional_hazards)"]
      }
    end
  end
end