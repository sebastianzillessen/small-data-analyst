class ModelsResearchQuestions < ActiveRecord::Migration
  def change
    create_table :models_research_questions do |t|
      t.references :model
      t.references :research_question
    end
  end
end
