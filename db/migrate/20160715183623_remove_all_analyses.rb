class RemoveAllAnalyses < ActiveRecord::Migration
  def change
    Analysis.destroy_all
  end
end
