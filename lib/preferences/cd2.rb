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


      cd2_p = QueryAssumption.find_or_initialize_by(name: "CD2_predict") do |cd|
        cd.question= "Intention of analysis: predict?"
        cd.description = "Preferences for CD2"
      end
      cd2_e= QueryAssumption.find_or_initialize_by(name: "CD2_explain") do |cd|
        cd.question= "Intention of analysis: explain?"
        cd.description= "Preferences for CD2"
      end

      cd2_p.save
      cd2_e.save

      [cd2_e, cd2_p]


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