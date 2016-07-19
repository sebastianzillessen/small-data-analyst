class CreatePreferenceArguments < ActiveRecord::Migration
  def change
    create_table :preference_arguments do |t|
      t.references :preference, index: true, foreign_key: true
      t.references :assumption, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
