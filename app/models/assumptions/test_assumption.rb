require 'r_script_execution'

class TestAssumption < Assumption
  validates :r_code, presence: true
  serialize :required_dataset_fields, Array
  before_validation :parse_required_dataset_fields, if: :required_dataset_fields_changed?
  validate :r_code_syntax, if: :r_code_changed?
  has_many :dataset_test_assumption_results, foreign_key: :assumption_id, dependent: :destroy

  after_save :update_dataset_test_assumptions_results
  after_create :generate_dataset_test_assumptions_results


  def evaluate(analysis)
    evaluate_critical(analysis)
  end

  def evaluate_critical(analysis_or_dataset)
    dataset = if (analysis_or_dataset.is_a? Dataset)
                analysis_or_dataset
              elsif analysis_or_dataset.is_a? Analysis
                analysis_or_dataset.dataset
              else
                raise ArgumentError, 'No analysis or dataset provided'
              end
    cached = self.dataset_test_assumption_results.where(dataset: dataset).first.try(:result)
    return cached unless cached.nil?
    @evaluate_critical ||= eval_internal(dataset)
  end

  def eval_internal(dataset)
    # TODO: Provide better output for user why the assumption does not hold
    return false unless check_dataset_mets_column_names(dataset) if required_dataset_fields.any?
    RScriptExecution.execute r_code, dataset.data
  rescue Exception => e
    puts "\n \n ERROR: #{e.inspect}\n While running on: #{self.inspect}"
    false
  end

  private
  def generate_dataset_test_assumptions_results
    Dataset.all.each do |d|
      self.dataset_test_assumption_results << DatasetTestAssumptionResult.create(dataset: d, test_assumption: self)
    end
  end


  def update_dataset_test_assumptions_results
    if (self.changed & ['r_code', 'required_dataset_fields']).any?
      dataset_test_assumption_results.each { |dtar| dtar.update }
    end
  end

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