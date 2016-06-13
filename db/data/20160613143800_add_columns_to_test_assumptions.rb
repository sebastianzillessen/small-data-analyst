class AddColumnsToTestAssumptions < ActiveRecord::Migration
  def load_data(file)
    IO.read(Rails.root.join("db/data/#{file}"))
  end

  def self.up
    a2=TestAssumption.find_by(name: 'a2')
    a3=TestAssumption.find_by(name: 'a3')
    a4=TestAssumption.find_by(name: 'a4')
    a7=TestAssumption.find_by(name: 'a7')
    a2.r_code = load_data('a2.r')
    a2.required_dataset_fields = []
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
