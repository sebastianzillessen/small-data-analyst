class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :name
      t.integer :stage
      t.references :user, index: true, foreign_key: true
      t.references :research_question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
