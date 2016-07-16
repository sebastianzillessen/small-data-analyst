require 'preferences/as2'
module Preferences

  # CD2 Model Intent
  # suitable ≻ neutral ≻ avoid

  # Context Domain     Model     Performance measure
  # predict             m1 KM     avoid
  #                     m2 PH     suitable
  #                     m4 χ2     avoid
  # explain             m1 KM     suitable
  #                     m2 PH     suitable
  #                     m4 χ2     neutral
  # => predict: m2 > > m1,m4
  # => explain: m1, m2 > m4 >
  # m1 kaplan_meier
  # m2 cox_proportional_hazards
  # m4 weibull
  #
  # predict -> (kaplan_meier -> cox), (weibull -> cox)
  # explain -> (weibull -> cox), (weibull -> kaplan_meier)
  class CD2 < AS2
    def self.stage
      3
    end


    def self.arguments
      ["CD2_predict", "CD2_explain"].map { |a| QueryAssumption.find_by(name: a) }
    end


    protected
    def self.all_rules
      {
          "CD2_predict": ["CD2_predict", "CD2_predict -> (weibull->cox_proportional_hazards)",
                          "CD2_predict -> (kaplan_meier->cox_proportional_hazards)",
          ],
          "CD2_explain": ["CD2_explain", "CD2_explain -> (weibull-> kaplan_meier)",
                          "CD2_explain -> (weibull-> cox_proportional_hazards)"]
      }
    end
  end
end