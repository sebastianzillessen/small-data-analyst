require 'csv'
class Dataset < ActiveRecord::Base
  has_many :analyses, dependent: :destroy
  has_many :dataset_test_assumption_results, dependent: :destroy
  has_many :query_test_assumption_plots, dependent: :destroy
  belongs_to :user
  serialize :columns, Array

  attr_accessor :data_file

  validates :data, presence: true
  validates :name, presence: true
  validates :columns, presence: true


  before_validation :parse_data_file
  before_validation :parse_columns, if: :data_changed?
  after_save :update_dataset_test_assumptions_results
  #after_create :generate_dataset_test_assumptions_results

  def rows
    @rows ||= CSV.parse(data).drop(1)
  rescue
    []
  end

  private

  def generate_dataset_test_assumptions_results
    TestAssumption.all.each do |ta|
      self.dataset_test_assumption_results << DatasetTestAssumptionResult.create(dataset: self, test_assumption: ta)
    end
  end

  def update_dataset_test_assumptions_results
    if (self.changed & ['data', 'columns']).any?
      dataset_test_assumption_results.each { |dtar| dtar.update }
      query_test_assumption_plots.each { |qtap| qtap.update }
    end
  end


  def parse_columns
    return unless data
    self.columns = CSV.parse(data)[0]
  rescue Exception => e
    errors.add(:data_file, "File cannot be parsed as CSV: #{e}")
    errors.add(:data, "Data cannot be parsed as CSV: #{e}")
  end

  def parse_data_file
    if (data_file)
      if data_file.respond_to?(:read)
        self.data = data_file.read
      elsif data_file.respond_to?(:path)
        self.data = File.read(data_file.path)
      else
        errors.add(:data_file, "File cannot be read")
      end
    end
  end
end
