require 'csv'
class Dataset < ActiveRecord::Base
  has_many :analyses, dependent: :destroy
  belongs_to :user
  serialize :columns, Array
  attr_accessor :data_file

  validates :data, presence: true
  validates :name, presence: true
  validates :columns, presence: true


  before_validation :parse_data_file
  before_validation :parse_columns, if: :data_changed?

  def rows
    @rows ||= CSV.parse(data).drop(1)
  rescue
    []
  end

  private

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
