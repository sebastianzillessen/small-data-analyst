class CreateResearchQuestions < ActiveRecord::Migration
  def change
    create_table :research_questions do |t|
      t.string :name
      t.text :description
      t.boolean :private

      t.timestamps null: false
    end
  end
end
