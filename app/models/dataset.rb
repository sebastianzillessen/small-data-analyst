require 'csv'
class Dataset < ActiveRecord::Base
  has_many :analyses
  serialize :columns, Array
  before_update :parse_columns, if: :data_changed?

  def rows
    @rows ||= CSV.parse(data).drop(1)
  rescue
    []
  end

  private

  def parse_columns
    return unless data
    self.columns = CSV.parse(data)[0]
  end
end
