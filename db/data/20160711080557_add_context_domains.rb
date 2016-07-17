class AddContextDomains < ActiveRecord::Migration
  def self.up
    QueryAssumption.all.select{|q| q.name.start_with?("CD")}.each{|a| a.destroy}
    puts "adding CD1 and CD2"
    cd1_n= QueryAssumption.create(name: "CD1_no", question: "Censoring: absent?", description: "Preferences for CD1")
    cd1_m= QueryAssumption.create(name: "CD1_mild", question: "Censoring: mild?", description: "Preferences for CD1")
    cd1_h= QueryAssumption.create(name: "CD1_heavy", question: "Censoring: heavy?", description: "Preferences for CD1")
    cd2_p= QueryAssumption.create(name: "CD2_predict", question: "Intention of analysis: predict?", description: "Preferences for CD2")
    cd2_e= QueryAssumption.create(name: "CD2_explain", question: "Intention of analysis: explain?", description: "Preferences for CD2")

    cd1_n.attacking = [cd1_h, cd1_m]
    cd1_m.attacking = [cd1_h, cd1_n]
    cd1_h.attacking = [cd1_m, cd1_n]

    cd2_p.attacking = [cd2_e]
    cd2_e.attacking = [cd2_p]
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
