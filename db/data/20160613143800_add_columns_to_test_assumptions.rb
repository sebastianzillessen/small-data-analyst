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
    a3.r_code = load_data('a3.r')
    a4.r_code = load_data('a4.r')
    a7.r_code = load_data('a7.r')

    a2.required_dataset_fields = ['fustat']
    a2.save

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
