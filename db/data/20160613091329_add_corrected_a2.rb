class AddCorrectedA2 < ActiveRecord::Migration
  def load_data(file)
    IO.read(Rails.root.join("db/data/#{file}"))
  end

  def self.up
    a2 = TestAssumption.find_by(name: "a2")
    a2.r_code = load_data("a2.r")
    a2.save
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
