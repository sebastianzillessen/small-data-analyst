module ASTwo
  class CD2 < AS2
    def self.level
      2
    end


    def self.arguments
      ["CD2_predict", "CD2_explain"]
    end


    protected
    def self.all_rules
      {
          "CD2_predict": ["CD2_predict -> (weibull->cox_proportional_hazards)",
                          "CD2_predict -> (weibull->kaplan_meier)",
                          "CD2_predict -> (kaplan_meier->cox_proportional_hazards)",
                          "CD2_predict -> (kaplan_meier->weibull)"],
          "CD2_explain": ["CD2_explain -> (cox_proportional_hazards->kaplan_meier)",
                          "CD2_explain -> (weibull-> kaplan_meier)",
                          "CD2_explain -> (kaplan_meier->cox_proportional_hazards)",
                          "CD2_explain -> (weibull-> cox_proportional_hazards)"]
      }
    end
  end
end