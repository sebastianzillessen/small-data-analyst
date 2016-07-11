module AS2
  class CD1 < AS2
    def self.level
      1
    end

    def self.arguments
      ["CD1_no", "CD1_mild", "CD1_heavy"]
    end

    protected
    def self.all_rules()
      {
          "CD1_no": ["CD1_no"],
          "CD1_mild": ["CD1_mild -> (weibull->cox_proportional_hazards)",
                       "CD1_mild -> (weibull->kaplan_meier)"],
          "CD1_heavy": ["CD1_heavy -> (weibull->cox_proportional_hazards)",
                        "CD1_heavy -> (weibull->kaplan_meier)",
                        "CD1_heavy -> (kaplan_meier->weibull)",
                        "CD1_heavy -> (kaplan_meier->cox_proportional_hazards)"]
      }
    end
  end
end