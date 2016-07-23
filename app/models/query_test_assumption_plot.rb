class QueryTestAssumptionPlot < ActiveRecord::Base
  belongs_to :query_test_assumption
  belongs_to :dataset
  belongs_to :plot, dependent: :destroy

  validates :query_test_assumption, presence: true
  validates :dataset, presence: true
  validates :plot, presence: true

  def update

  end

end
