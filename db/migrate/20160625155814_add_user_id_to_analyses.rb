class AddUserIdToAnalyses < ActiveRecord::Migration
  def change
    add_column :analyses, :user_id, :integer
    add_index :analyses, :user_id

    add_column :models, :user_id, :integer
    add_index :models, :user_id

    add_column :research_questions, :user_id, :integer
    add_index :research_questions, :user_id

    add_column :assumptions, :user_id, :integer
    add_index :assumptions, :user_id

  end
end
