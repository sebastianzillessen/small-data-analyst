class CreateAnalyses < ActiveRecord::Migration
  def change
    create_table :analyses do |t|
      t.boolean :in_progress, default: true
      t.references :research_question, index: true, foreign_key: true
      t.boolean :private

      t.timestamps null: false
    end
  end
end
