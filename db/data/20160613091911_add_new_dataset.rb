class AddNewDataset < ActiveRecord::Migration
  def load_data(file)
    IO.read(Rails.root.join("db/data/#{file}"))
  end
  def self.up
    ovarian = Dataset.create(name: 'ovarian-without-a2', description: 'Contains the survival in a randomised trial comparing two treatments for ovarian cancer',
                             data: load_data('ovarian_no_a2.csv'),
                             columns: ["", "futime", "fustat", "age", "resid.ds", "rx", "ecog.ps"])
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
