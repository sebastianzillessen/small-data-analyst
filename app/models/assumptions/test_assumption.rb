require 'r_script_execution'

class TestAssumption < Assumption
  validates :r_code, presence: true
  serialize :required_dataset_fields, Array
  before_validation :parse_required_dataset_fields, if: :required_dataset_fields_changed?
  validate :r_code_syntax, if: :r_code_changed?

  def evaluate_critical(analysis)
    # TODO: Provide better output for user why the assumption does not hold
    return false unless check_dataset_mets_column_names(analysis.dataset) if required_dataset_fields.any?
    RScriptExecution.execute r_code, analysis.dataset.data
  rescue Exception => e
    puts "\n \n ERROR: #{e.inspect}\n While running on: #{self.inspect}"
    false
  end


  private

  def check_dataset_mets_column_names(dataset)
    (required_dataset_fields - dataset.columns).empty?
  end

  def parse_required_dataset_fields
    puts "Parse required dataset fields #{self.required_dataset_fields}"
    if self.required_dataset_fields.is_a? String || self.required_dataset_fields.is_a?(Array)
      self.required_dataset_fields = self.required_dataset_fields.join(",").split(/\s*,\s*/).uniq
    end
  end

  def r_code_syntax
    #TODO: Validate R-Syntax
  end
end